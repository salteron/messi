# frozen_string_literal: true

class MessagesController < ApplicationController
  def create
    result = MessageCreatorService.new(params.permit!.to_h).create!

    if result.success?
      render json: {id: result.payload.id}, status: :created
    else
      render json: result.errors, status: :unprocessable_entity
    end
  end
end
