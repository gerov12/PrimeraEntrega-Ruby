class GridsController < ApplicationController
  # GET /grids/new
  def new
    @grid = Grid.new
  end

  # POST /grids
  def grid_create
    @grid = Grid.new(grid_params)
    if @grid.valid?
      send_file(@grid.generate())
    else
      redirect_to professionals_url, notice: "Plase select correct values for the grid generation."
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def grid_params
      params.require(:grid).permit(:date, :type, :professional)
    end
end
