import axios from 'axios';
import { camelizeKeys, decamelizeKeys } from 'humps';
import map from 'lodash/map';
import capitalize from 'lodash/capitalize';

const tokenEl = document && document.querySelector('meta[name="csrf-token"]');
const CSRFToken = tokenEl && tokenEl.getAttribute('content');

const api = axios.create({
  headers: {
    'X-CSRF-Token': CSRFToken,
  },
});

api.interceptors.response.use(
  response => {
    if (response.data && response.headers['content-type'].match('application/json')) {
      response.data = camelizeKeys(response.data);
    }

    return response;
  },
  error => {
    if (error.response) {
      const { data } = error.response;
      switch (data.message) {
      case 'invalid_attributes':
        error.details = map(data.errors, (errorMessage, attribute) => capitalize(`${attribute} ${errorMessage}`));
        break;
      case 'server_error':
        error.details = [`Error interno del servidor: ${data.detail}`];
        break;
      default:
        break;
      }
    }

    return Promise.reject(error);
  },
);

api.interceptors.request.use(config => {
  const newConfig = { ...config };
  if (newConfig.headers['Content-Type'] === 'multipart/form-data') {
    return newConfig;
  }
  if (config.params) {
    newConfig.params = decamelizeKeys(config.params);
  }
  if (config.data) {
    newConfig.data = decamelizeKeys(config.data);
  }

  return newConfig;
});

export default api;
