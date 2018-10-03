class IcDocumentsController < ApplicationController
  def download
  end

  # Utilisé pour downloader le document
  def show
    icdocument = IcDocument.find(params[:id])
    which = (params[:which] || 'original').to_sym
    @document = icdocument.send(which)
    # TODO Comment le télécharger ?
    # redirect_back(fallback_location: root_path)
  end

  def edit
  end
end
