module JsonHelper
  def camelize_hash(hash)
    hash.deep_transform_keys! { |key| key.camelize(:lower) }
  end

  def camelize_records(collection)
    collection.as_json.map { |record_hash| camelize_hash record_hash }
  end
end
