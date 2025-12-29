import api from './api'

export async function listProviders() {
  return api.get('/sso/providers')
}

export async function createProvider(payload) {
  return api.post('/sso/providers', payload)
}

export async function testProvider(id) {
  return api.post(`/sso/providers/${id}/test`)
}

export async function updateProvider(id, payload) {
  return api.put(`/sso/providers/${id}`, payload)
}

export async function deleteProvider(id) {
  return api.delete(`/sso/providers/${id}`)
}
import api from './api'

export async function listProviders() {
  return api.get('/sso/providers')
}

export async function createProvider(payload) {
  return api.post('/sso/providers', payload)
}

export async function testProvider(id) {
  return api.post(`/sso/providers/${id}/test`)
}

export async function updateProvider(id, payload) {
  return api.put(`/sso/providers/${id}`, payload)
}

export async function deleteProvider(id) {
  return api.delete(`/sso/providers/${id}`)
}
