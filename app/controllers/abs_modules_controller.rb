class AbsModulesController < ApplicationController
  def index
    @absmodules = AbsModule.all
  end

  # Afficher un module absolu en particulier
  def show
    @amodule = AbsModule.find(params[:id])
  end

  # Updater les données d'un module d'apprentissage en particulier
  def update
    mdata = params[:module]
    AbsModule.find(params[:id]).update titre: mdata[:titre],
      dim: mdata[:dim],
      short_description: mdata[:short_description],
      long_description: mdata[:long_description]
    redirect_to "/modules/#{params[:id]}"
  end

  def create
    mdata = params[:module]
    # Création du module d'apprentissage
    AbsModule.create titre: mdata[:titre],
      dim: mdata[:dim],
      short_description: mdata[:short_description],
      long_description: mdata[:long_description]

    redirect_to '/modules'
  end

  def destroy
    AbsModule.destroy(params[:id])
    redirect_to '/modules'
  end
end
