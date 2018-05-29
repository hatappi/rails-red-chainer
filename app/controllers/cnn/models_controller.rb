class Cnn::ModelsController < ApplicationController
  # GET /cnn/models
  # GET /cnn/models.json
  def index
    logs = RedChainer::Log.load_from_log(Rails.root.join("data/vgg/log"))
    vgg_accuracies = logs.map { |log| [log.epoch, log.main_accuracy] }
    @vgg_accuracies = [%w(epoch, accuracy)] + vgg_accuracies
    vgg_losses = logs.map { |log| [log.epoch, log.main_loss] }
    @vgg_losses = [%w(epoch, loss)] + vgg_losses

    logs = RedChainer::Log.load_from_log(Rails.root.join("data/resnet-18/log"))
    resnet18_accuracies = logs.map { |log| [log.epoch, log.main_accuracy] }
    @resnet18_accuracies = [%w(epoch, accuracy)] + resnet18_accuracies
    resnet18_losses = logs.map { |log| [log.epoch, log.main_loss] }
    @resnet18_losses = [%w(epoch, loss)] + resnet18_losses
  end

  def show(model_name:, epoch: 1, limit: 50)
    logs = RedChainer::Log.load_from_log(Rails.root.join("data/#{model_name}/log"))
    @logs = Kaminari.paginate_array(logs).page(epoch).per(1)
    log = @logs.first
    dir = Rails.public_path.join("cifar10/#{model_name}/snapshot_iter_#{log.iteration}")
    files = dir.glob('*/**')
    @images_by_label = files.group_by { |file| file.to_s.match(%{#{dir}/([^/]+)/})[1] }
    @limit = limit
    @epoch = epoch
    @model_name = model_name
  end
end
