class UserProfile < ApplicationRecord
  # Associations
  enum role: { :Total => 0, :Parcial => 1 }
  belongs_to :user, optional: true

  validates_presence_of :name, :student_number
  validates_length_of :student_number, maximum: 10, allow_blank: false

  #paperclip
  # "#" instead ">": cut from the middle
  has_attached_file :picture, #styles: { medium: '300x300#', thumb: '100x100#' },
                    default_url: "usuario_padrao.png" #configura tamanho da imagem e se nao tiver, gera a imagem padrao
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/ #aceeita qlq tipo de imagem

end
