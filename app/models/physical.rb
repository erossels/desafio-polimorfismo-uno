class Physical < Product
  has_many :photos, as: :photoable
end
