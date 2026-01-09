'use strict';

const request = require('supertest');
const { createStrapi } = require('@strapi/strapi');

let strapi;

beforeAll(async () => {
  strapi = await createStrapi().load();
  await strapi.server.mount();
});

afterAll(async () => {
  if (strapi) {
    await strapi.destroy();
  }
});

test('creates a user successfully', async () => {
  const response = await request(strapi.server.httpServer)
    .post('/api/users')
    .send({
      name: 'Nguyen Van A',
      email: 'a+test1@gmail.com',
      has_entrance_exam: true,
      is_active: true,
      is_verified: false,
    });

  expect(response.status).toBe(201);
  expect(response.body).toMatchObject({
    name: 'Nguyen Van A',
    email: 'a+test1@gmail.com',
    has_entrance_exam: true,
    is_active: true,
    is_verified: false,
  });
  expect(response.body.id).toBeDefined();
});

test('rejects missing required field', async () => {
  const response = await request(strapi.server.httpServer)
    .post('/api/users')
    .send({
      email: 'a+test2@gmail.com',
    });

  expect(response.status).toBe(400);
  expect(response.body.error).toBeDefined();
});

test('rejects invalid field type', async () => {
  const response = await request(strapi.server.httpServer)
    .post('/api/users')
    .send({
      name: 'Nguyen Van B',
      email: 'a+test3@gmail.com',
      is_active: 'yes',
    });

  expect(response.status).toBe(400);
  expect(response.body.error).toBeDefined();
});
