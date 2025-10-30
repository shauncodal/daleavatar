const request = require('supertest');
const { createApp } = require('../src/app.js');
const { describe, it } = require('mocha');
const { expect } = require('chai');

describe('health', () => {
  it('returns ok', async () => {
    const app = createApp();
    const res = await request(app).get('/health');
    expect(res.status).toBe(200);
    expect(res.body.ok).toBe(true);
  });
});

