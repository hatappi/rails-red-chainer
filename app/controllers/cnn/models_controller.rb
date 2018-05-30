class Cnn::ModelsController < ApplicationController
  # GET /cnn/models
  # GET /cnn/models.json
  def index
    logs = RedChainer::Log.load_from_log(Rails.root.join("data/vgg/log"))
    @vgg_epochs = logs.map(&:epoch)
    @vgg_accuracies = logs.map { |l| l.main_accuracy.floor(3) }
    @vgg_losses = logs.map { |l| l.main_loss.floor(3) }

    logs = RedChainer::Log.load_from_log(Rails.root.join("data/resnet-18/log"))
    @resnet18_epochs = logs.map(&:epoch)
    @resnet18_accuracies = logs.map { |l| l.main_accuracy.floor(3) }
    @resnet18_losses = logs.map { |l| l.main_loss.floor(3) }
  end

  def show(model_name:, epoch: 1, limit: 50)
    logs = RedChainer::Log.load_from_log(Rails.root.join("data/#{model_name}/log"))
    @logs = Kaminari.paginate_array(logs).page(epoch).per(1)
    @log = @logs.first
    dir = Rails.public_path.join("cifar10/#{model_name}/snapshot_iter_#{@log.iteration}")
    files = dir.glob('*/**')
    @images_by_label = files.group_by { |file| file.to_s.match(%{#{dir}/([^/]+)/})[1] }
    @limit = limit
    @epoch = epoch
    @model_name = model_name
  end
end
