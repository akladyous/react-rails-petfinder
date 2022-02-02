class PetsController < ApplicationController
    skip_before_action :authenticate_user, only: [:show, :create] 
    before_action :current_pet, only: [:show, :update, :destroy]

    def show
        if @pet
            render json: @pet, status: :ok
        else
            render json: {error: "Pet not found"}, status: :not_found
        end
    end

    def create
        @pet = Pet.new(pet_params.except(:id))
        if @pet.save
            render json: @pet, status: :ok
        else
            render json: {error: "Unable to create Pet profile"}, status: :unprocessable_entity
        end
    end

    def update
        if @pet
            @pet.update(pet_params)
            if @pet.save
                render json: @pet, status: :ok
            else
                render json: {error: "Unable to update Pet profile"}, status: :unprocessable_entity
            end
        else
            render json: {error: "Pet not found"}, status: :not_found
        end
    end

    def destroy
        if @pet
            @pet.destroy
            if @pet.destroyed?
                render json: {}, status: :ok
            else
                render json: {error: "Unable to delete Pet profile"}, status: :unprocessable_entity
            end
        else
            render json: {error: "Pet profile not found"}, status: :not_found
        end
    end


    private
    def pet_params
        params.permit(:id, :species, :name, :age, :size, :description, :breed, :gender, :color, :microchip, :height, :weight, :coat, :collar, :image_file)
    end
    def current_pet
        @pet = Pet.find_by_id!(pet_params[:id])
    end
end
