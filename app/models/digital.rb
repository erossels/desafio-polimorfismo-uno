class Digital < Product
  has_one :photo, as: :photoable 
end
