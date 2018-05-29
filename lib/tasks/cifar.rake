require 'datasets'
require 'chainer'

namespace :cifar do
  task :vgg, ['epoch'] => :environment do |_, args|
    export_image(model_name: 'vgg', epoch: args[:epoch])
  end

  task :resnet18, ['epoch'] => :environment do |_, args|
    export_image(model_name: 'resnet-18', epoch: args[:epoch])
  end

  def export_image(model_name:, epoch: 1)
    logs = RedChainer::Log.load_from_log(Rails.root.join("data/#{model_name}/log"))
    puts "loading test datasets"
    test_data = []
    test_labels = []
    Datasets::CIFAR.new(n_classes: 10, type: :test).each do |record|
      test_data << record.pixels
      test_labels << record.label
    end
    test = Chainer::Datasets::CIFAR.preprocess_cifar(Numo::UInt8[*test_data], Numo::UInt8[*test_labels], true, 3, 1.0)

    logs.each do |log|
      next if log.epoch < epoch.to_i
      m = if model_name == "vgg"
            RedChainer::VGG::Model.new
          elsif model_name == "resnet-18"
            RedChainer::ResNet18::Model.new
          end
      snapshot_name = "snapshot_iter_#{log.iteration}"
      puts "snapshot_name: #{snapshot_name}"
      file_path = Rails.root.join("data/#{model_name}/#{snapshot_name}")
      m.load(file_path: file_path)

      offset = 0
      limit = 100

      loop do
        puts "offset #{offset}"
        datasets = Numo::SFloat.[](*test[offset...(offset + limit)].map { |t| t.first.to_a })
        labels = test[offset...(offset + limit)].map(&:second)

        y = m.(datasets)
        expects = y.data.max_index(1).to_a.map.with_index { |val, idx| val - y.shape[1] * idx }

        idx = 0
        expects.zip(labels) do |e, l|
          suffix = (e == l) ? 1 : 0
          pixels = (datasets[idx, false] * 255).cast_to(Numo::Int32).reshape(3, 32 * 32).transpose.to_a
          img = Magick::Image.new(32, 32)
          d = Magick::Draw.new
          32.times do |y|
            32.times do |x|
              rgb = pixels.shift
              d.fill("rgb(#{rgb.join(',')})")
              d.point(x, y)
            end
          end
          d.draw(img)

          name = CIFAR10::LABELS[e]
          dir = Rails.public_path.join("cifar10/#{model_name}/#{snapshot_name}/#{name}")
          dir.mkpath
          output_path = dir.join("#{Dir.glob("#{dir}/*").count + 1}_#{suffix}.jpg")
          img.write(output_path)
          idx += 1
        end
        offset += limit
        break if offset >= 10000
      end
    end
  end
end
