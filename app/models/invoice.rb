class Invoice < ApplicationRecord
  belongs_to :member
  # has_one_attached :attachment
  # before_save :analyze_attachment

  def small_image_url
    attachment.variant(resize: '200x113').processed
  end

  def medium_image_url
    attachment.variant(resize: '1024x576').processed
  end

  # Extracts informations like image dimensions and saves them in blob metadata.
  def analyze_attachment
    if self.attachment
      self.attachment.analyze
    end
  end
end
