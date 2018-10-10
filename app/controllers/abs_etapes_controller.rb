class AbsEtapesController < ApplicationController
  def index
  end

  def show
    @absetape = AbsEtape.find(params[:id])
  end
end
