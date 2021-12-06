class AppointmentsController < ApplicationController
  load_and_authorize_resource :professional
  load_and_authorize_resource :appointment, through: :professional

  # GET /appointments or /appointments.json
  def index
    @appointments = @professional.appointments
    # Solo trae a los appointments que dependan del professional

    if filter_params[:f].present?
      @appointments = @appointments.filter_by_date(filter_params[:f])
    end

    @f = filter_params[:f]
  end

  # GET /appointments/1 or /appointments/1.json
  def show
  end

  # GET /appointments/new
  def new
    @appointment = @professional.appointments.new
  end

  # GET /appointments/1/edit
  def edit
  end

  # POST /appointments or /appointments.json
  def create
    @appointment = @professional.appointments.new(appointment_params)

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to [@professional, @appointment], notice: "Appointment was successfully created." }
        format.json { render :show, status: :created, location: @appointment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appointments/1 or /appointments/1.json
  def update
    respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to [@professional, @appointment], notice: "Appointment was successfully updated." }
        format.json { render :show, status: :ok, location: @appointment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    respond_to do |format|
      if @appointment.can_be_deleted?
        @appointment.destroy
        format.html { redirect_to professional_appointments_url, notice: "Appointment was successfully destroyed." }
        format.json { head :no_content }
      else
        format.html { redirect_to professional_appointments_url, notice: "Can't cancel past appointments." }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    # Only allow a list of trusted parameters through.
    def appointment_params
      params.require(:appointment).permit(:date, :surname, :name, :phone, :note)
    end

    def filter_params
      if params.key?(:filters)
        params.require(:filters).permit(:f) 
      else
        {}
      end
    end
end
