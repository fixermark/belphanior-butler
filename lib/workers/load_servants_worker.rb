class LoadServantsWorker < BackgrounDRb::MetaWorker
  set_worker_name :load_servants_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end

  def update_workers
    logger.info "Updating workers..."
  end
end

