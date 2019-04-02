function get(map, key, values) {
  if (!localStorage[map]) {
    return 0;
  }
  const mapKeyToValue = JSON.parse(localStorage[map]);
  if (!mapKeyToValue.hasOwnProperty(key)) {
    return 0;
  }
  if (values === null) {
    return 0;
  }
  const valueId = mapKeyToValue[key];
  const index = values.findIndex(value => value.id === valueId);
  if (index >= 0) {
    return index;
  }
  return 0;
}

function set(map, key, value) {
  const mapKeyToValue = localStorage[map] ? JSON.parse(localStorage[map]) : {};
  mapKeyToValue[key] = value;
  localStorage[map] = JSON.stringify(mapKeyToValue);
}

export default { get, set };
