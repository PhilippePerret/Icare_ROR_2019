class IcDocumentsController < ApplicationController

  def download
  end

  # Utilisé pour downloader le document (vraiment ?)
  def show
    icdocument = IcDocument.find(params[:id])
    which = (params[:which] || 'original').to_sym
    @document = icdocument.send(which)
  end

  def edit
  end
end
