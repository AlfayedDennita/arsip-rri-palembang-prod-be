const request = require('supertest');

const app = require('../../server');
const db = require('../../models');

const apiKey = process.env.API_KEY;
const username = 'integration-tester';
const password = 'abcd1234';

let accessToken = '';
let scopeId = '';
const archiveCode = 'IT/1';
let archiveCodeId = '';

let pdfArchiveId = '';
let imagesArchiveId = '';
const pdfArchiveTitle = 'Arsip PDF';
const imagesArchiveTitle = 'Arsip Gambar';
const newPDFArchiveTitle = 'Arsip PDF Baru';
const newImagesArchiveTitle = 'Arsip Gambar Baru';
const query = 'apa itu rri palembang?';

beforeAll(async () => {
  try {
    await db.sequelize.authenticate();
    await db.sequelize.sync();
  } catch (error) {
    console.error('Unable to connect to the database:', error);
  }
});

afterAll(async () => {
  try {
    await db.sequelize.close();
  } catch (error) {
    console.error('Unable to close the database connection:', error);
  }
});

describe('Integrasi Antar-modul dalam Alur RAG', () => {
  it('harus berhasil memberikan access token ketika masuk dengan username dan kata sandi benar', async () => {
    const response = await request(app)
      .post('/auth/login')
      .set('x-api-key', apiKey)
      .send({ identifier: username, password });

    expect(response.status).toBe(200);
    expect(response.body.status).toEqual('success');
    expect(response.body.message).toEqual(
      'User successfully logged in. Access token and refresh token created.'
    );
    expect(response.body.data.user.username).toEqual(username);
    expect(response.body.data.accessToken).not.toBeFalsy();

    accessToken = response.body.data.accessToken;
  });

  it('harus berhasil mendapatkan semua cakupan dengan access token yang didapat sebelumnya', async () => {
    const response = await request(app)
      .get('/scopes')
      .set('x-api-key', apiKey)
      .set('Authorization', `Bearer ${accessToken}`);

    expect(response.status).toBe(200);
    expect(response.body.status).toEqual('success');
    expect(response.body.message).toEqual('All scopes successfully retrieved.');
    expect(response.body.data.scopes.id).not.toBeFalsy();

    scopeId = response.body.data.scopes.id;
  });

  it('harus berhasil menambahkan kode arsip dengan ID cakupan teratas yang didapat sebelumnya', async () => {
    const response = await request(app)
      .post('/archive-codes')
      .set('x-api-key', apiKey)
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ code: archiveCode, scopeId });

    expect(response.status).toBe(201);
    expect(response.body.status).toEqual('success');
    expect(response.body.message).toEqual('Archive code successfully created.');
    expect(response.body.data.archiveCode.code).toEqual(archiveCode);
    expect(response.body.data.archiveCode.ScopeId).toEqual(scopeId);

    archiveCodeId = response.body.data.archiveCode.id;
  });

  it(
    'harus berhasil menambahkan arsip PDF dengan ID kode arsip yang didapat sebelumnya',
    async () => {
      const response = await request(app)
        .post('/archives')
        .set('x-api-key', apiKey)
        .set('Authorization', `Bearer ${accessToken}`)
        .field('archiveCodeId', archiveCodeId)
        .field('title', pdfArchiveTitle)
        .attach('pdf', '__tests__/assets/1.pdf');

      expect(response.status).toBe(201);
      expect(response.body.status).toEqual('success');
      expect(response.body.message).toEqual('Archive successfully created.');
      expect(response.body.data.archive.title).toEqual(pdfArchiveTitle);
      expect(response.body.data.archive.type).toEqual('pdf');
      expect(response.body.data.archive.ArchiveFiles).toHaveLength(1);

      pdfArchiveId = response.body.data.archive.id;
    },
    60 * 1000
  ); // Timeout 1 minutes

  it(
    'harus berhasil menambahkan arsip gambar dengan ID kode arsip yang didapat sebelumnya',
    async () => {
      const response = await request(app)
        .post('/archives')
        .set('x-api-key', apiKey)
        .set('Authorization', `Bearer ${accessToken}`)
        .field('archiveCodeId', archiveCodeId)
        .field('title', imagesArchiveTitle)
        .attach('images', '__tests__/assets/4.jpg');

      expect(response.status).toBe(201);
      expect(response.body.status).toEqual('success');
      expect(response.body.message).toEqual('Archive successfully created.');
      expect(response.body.data.archive.title).toEqual(imagesArchiveTitle);
      expect(response.body.data.archive.type).toEqual('images');
      expect(response.body.data.archive.ArchiveFiles).toHaveLength(1);

      imagesArchiveId = response.body.data.archive.id;
    },
    60 * 1000
  ); // Timeout 1 minutes

  it('harus berhasil mendapatkan arsip PDF dengan ID arsip yang didapat sebelumnya', async () => {
    const response = await request(app)
      .get(`/archives/${pdfArchiveId}`)
      .set('x-api-key', apiKey)
      .set('Authorization', `Bearer ${accessToken}`);

    expect(response.status).toBe(200);
    expect(response.body.status).toEqual('success');
    expect(response.body.message).toEqual('Archive successfully retrieved.');
    expect(response.body.data.archive.id).toEqual(pdfArchiveId);
    expect(response.body.data.archive.title).toEqual(pdfArchiveTitle);
    expect(response.body.data.archive.type).toEqual('pdf');
    expect(response.body.data.archive.ArchiveFiles).toHaveLength(1);
  });

  it('harus berhasil mendapatkan arsip gambar dengan ID arsip yang didapat sebelumnya', async () => {
    const response = await request(app)
      .get(`/archives/${imagesArchiveId}`)
      .set('x-api-key', apiKey)
      .set('Authorization', `Bearer ${accessToken}`);

    expect(response.status).toBe(200);
    expect(response.body.status).toEqual('success');
    expect(response.body.message).toEqual('Archive successfully retrieved.');
    expect(response.body.data.archive.id).toEqual(imagesArchiveId);
    expect(response.body.data.archive.title).toEqual(imagesArchiveTitle);
    expect(response.body.data.archive.type).toEqual('images');
    expect(response.body.data.archive.ArchiveFiles).toHaveLength(1);
  });

  it('harus berhasil mendapatkan arsip PDF dan gambar', async () => {
    const response = await request(app)
      .get('/archives')
      .set('x-api-key', apiKey)
      .set('Authorization', `Bearer ${accessToken}`);

    expect(response.status).toBe(200);
    expect(response.body.status).toEqual('success');
    expect(response.body.message).toEqual(
      'All archives successfully retrieved.'
    );
    expect(response.body.data.totalRecords).toBeGreaterThanOrEqual(2);
    expect(response.body.data.archives.length).toBeGreaterThanOrEqual(2);
  });

  it('harus berhasil memperbarui judul arsip PDF dengan ID arsip yang didapat sebelumnya', async () => {
    const response = await request(app)
      .patch(`/archives/${pdfArchiveId}`)
      .set('x-api-key', apiKey)
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ title: newPDFArchiveTitle });

    expect(response.status).toBe(200);
    expect(response.body.status).toEqual('success');
    expect(response.body.message).toEqual('Archive successfully patched.');
    expect(response.body.data.archive.id).toEqual(pdfArchiveId);
    expect(response.body.data.archive.title).toEqual(newPDFArchiveTitle);
    expect(response.body.data.archive.type).toEqual('pdf');
    expect(response.body.data.archive.ArchiveFiles).toHaveLength(1);
  });

  it('harus berhasil memperbarui judul arsip gambar dengan ID arsip yang didapat sebelumnya', async () => {
    const response = await request(app)
      .patch(`/archives/${imagesArchiveId}`)
      .set('x-api-key', apiKey)
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ title: newImagesArchiveTitle });

    expect(response.status).toBe(200);
    expect(response.body.status).toEqual('success');
    expect(response.body.message).toEqual('Archive successfully patched.');
    expect(response.body.data.archive.id).toEqual(imagesArchiveId);
    expect(response.body.data.archive.title).toEqual(newImagesArchiveTitle);
    expect(response.body.data.archive.type).toEqual('images');
    expect(response.body.data.archive.ArchiveFiles).toHaveLength(1);
  });

  it(
    'harus berhasil mendapatkan respons AI serta arsip PDF dan gambar pada pencarian semantik',
    async () => {
      const response = await request(app)
        .get(`/archives/semantic-search`)
        .set('x-api-key', apiKey)
        .set('Authorization', `Bearer ${accessToken}`)
        .query({ query });

      expect(response.status).toBe(200);
      expect(response.body.status).toEqual('success');
      expect(response.body.message).toEqual(
        'Archives successfully retrieved. Response successfully generated.'
      );
      expect(response.body.data.response).not.toBeFalsy();
      expect(response.body.data.archives.length).toBeGreaterThanOrEqual(2);
    },
    10 * 60 * 1000
  );

  it(
    'harus berhasil menghapus arsip PDF dengan ID arsip yang didapat sebelumnya',
    async () => {
      const response = await request(app)
        .delete(`/archives/${pdfArchiveId}`)
        .set('x-api-key', apiKey)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(response.status).toBe(200);
      expect(response.body.status).toEqual('success');
      expect(response.body.message).toEqual('Archive successfully deleted.');
      expect(response.body.data.archive.id).toEqual(pdfArchiveId);
    },
    60 * 1000
  ); // Timeout 1 minutes

  it(
    'harus berhasil menghapus arsip gambar dengan ID arsip yang didapat sebelumnya',
    async () => {
      const response = await request(app)
        .delete(`/archives/${imagesArchiveId}`)
        .set('x-api-key', apiKey)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(response.status).toBe(200);
      expect(response.body.status).toEqual('success');
      expect(response.body.message).toEqual('Archive successfully deleted.');
      expect(response.body.data.archive.id).toEqual(imagesArchiveId);
    },
    60 * 1000
  ); // Timeout 1 minutes

  it('harus berhasil menghapus kode arsip dengan ID kode arsip yang didapat sebelumnya', async () => {
    const response = await request(app)
      .delete(`/archive-codes/${archiveCodeId}`)
      .set('x-api-key', apiKey)
      .set('Authorization', `Bearer ${accessToken}`);

    expect(response.status).toBe(200);
    expect(response.body.status).toEqual('success');
    expect(response.body.message).toEqual('Archive code successfully deleted.');
    expect(response.body.data.archiveCode.id).toEqual(archiveCodeId);
  });

  it('harus berhasil keluar dari sistem', async () => {
    const response = await request(app)
      .post('/auth/logout')
      .set('x-api-key', apiKey)
      .set('Authorization', `Bearer ${accessToken}`);

    expect(response.status).toBe(200);
    expect(response.body.status).toEqual('success');
    expect(response.body.message).toEqual(
      'User successfully logged out. Refresh token deleted.'
    );
    expect(response.body.data.user.username).toEqual(username);
  });
});
