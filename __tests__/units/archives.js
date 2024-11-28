const crypto = require('crypto');
const request = require('supertest');

const app = require('../../server');
const db = require('../../models');

const apiKey = process.env.API_KEY;
const accessToken =
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkY2ZmYjc4YS05NTY0LTQwZjUtODYyMS03OTk2ODliZGRkODkiLCJpYXQiOjE3MjMwMDA5MjIsImV4cCI6MTcyMzAwNDUyMiwiaXNzIjoiQXJzaXAgRGlnaXRhbCBSUkkgUGFsZW1iYW5nIn0.gSsTnHt66CXk1mF4t7iaIFMNteI4KXceeo9WmBfP_Sc';
const archiveCodeId = '9531c802-f8bb-4612-8276-64fa87a36ec3';

let pdfArchiveId = '';
let imagesArchiveId = '';
const pdfArchiveTitle = 'Arsip PDF';
const imagesArchiveTitle = 'Arsip Gambar';

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

// ---------- POST /archives ----------

describe('POST /archives (Menambahkan Satu Arsip)', () => {
  it('harus gagal ketika tidak melampirkan kunci API pada header', async () => {
    const response = await request(app).post('/archives');

    expect(response.status).toBe(401);
    expect(response.body.status).toEqual('fail');
    expect(response.body.message).toEqual('API key is invalid.');
  });

  it('harus gagal ketika tidak melampirkan access token pada header', async () => {
    const response = await request(app)
      .post('/archives')
      .set('x-api-key', apiKey);

    expect(response.status).toBe(401);
    expect(response.body.status).toEqual('fail');
    expect(response.body.message).toEqual('Unauthorized. Need access token.');
  });

  it('harus gagal ketika tidak melampirkan ID kode arsip pada body', async () => {
    const response = await request(app)
      .post('/archives')
      .set('x-api-key', apiKey)
      .set('Authorization', `Bearer ${accessToken}`);

    expect(response.status).toBe(400);
    expect(response.body.status).toEqual('fail');
    expect(response.body.message).toEqual('Validation error.');
    expect(response.body.validationErrors[0].path).toEqual('archiveCodeId');
    expect(response.body.validationErrors[0].msg).toEqual(
      'Archive code is required.'
    );
  });

  it('harus gagal ketika tidak melampirkan judul arsip pada body', async () => {
    const response = await request(app)
      .post('/archives')
      .set('x-api-key', apiKey)
      .set('Authorization', `Bearer ${accessToken}`)
      .field('archiveCodeId', archiveCodeId);

    expect(response.status).toBe(400);
    expect(response.body.status).toEqual('fail');
    expect(response.body.message).toEqual('Validation error.');
    expect(response.body.validationErrors[0].path).toEqual('title');
    expect(response.body.validationErrors[0].msg).toEqual('Title is required.');
  });

  it('harus gagal ketika tidak melampirkan dokumen arsip pada body', async () => {
    const response = await request(app)
      .post('/archives')
      .set('x-api-key', apiKey)
      .set('Authorization', `Bearer ${accessToken}`)
      .field('archiveCodeId', archiveCodeId)
      .field('title', pdfArchiveTitle);

    expect(response.status).toBe(400);
    expect(response.body.status).toEqual('fail');
    expect(response.body.message).toEqual('Archive file is needed.');
  });

  it(
    'harus berhasil menambahkan arsip PDF ketika semua permintaan wajib server terpenuhi',
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
    'harus berhasil menambahkan arsip gambar ketika semua permintaan wajib server terpenuhi',
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
});

// ---------- GET /archives/:id ----------

const wrongArchiveId = crypto.randomUUID();

describe('GET /archives/:id (Mendapatkan Satu Arsip)', () => {
  it('harus gagal ketika tidak melampirkan kunci API pada header', async () => {
    const response = await request(app).get(`/archives/${wrongArchiveId}`);

    expect(response.status).toBe(401);
    expect(response.body.status).toEqual('fail');
    expect(response.body.message).toEqual('API key is invalid.');
  });

  it('harus gagal ketika tidak melampirkan access token pada header', async () => {
    const response = await request(app)
      .get(`/archives/${wrongArchiveId}`)
      .set('x-api-key', apiKey);

    expect(response.status).toBe(401);
    expect(response.body.status).toEqual('fail');
    expect(response.body.message).toEqual('Unauthorized. Need access token.');
  });

  it('harus gagal ketika ID arsip tidak ditemukan', async () => {
    const response = await request(app)
      .get(`/archives/${wrongArchiveId}`)
      .set('x-api-key', apiKey)
      .set('Authorization', `Bearer ${accessToken}`);

    expect(response.status).toBe(400);
    expect(response.body.status).toEqual('fail');
    expect(response.body.message).toEqual('Validation error.');
    expect(response.body.validationErrors[0].path).toEqual('id');
    expect(response.body.validationErrors[0].msg).toEqual('Archive not found.');
  });

  it('harus berhasil mendapatkan arsip PDF ketika semua permintaan wajib server terpenuhi', async () => {
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

  it('harus berhasil mendapatkan arsip gambar ketika semua permintaan wajib server terpenuhi', async () => {
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
});

// ---------- GET /archives ----------

describe('GET /archives (Mendapatkan Seluruh Arsip)', () => {
  it('harus gagal ketika tidak melampirkan kunci API pada header', async () => {
    const response = await request(app).get('/archives');

    expect(response.status).toBe(401);
    expect(response.body.status).toEqual('fail');
    expect(response.body.message).toEqual('API key is invalid.');
  });

  it('harus gagal ketika tidak melampirkan access token pada header', async () => {
    const response = await request(app)
      .get('/archives')
      .set('x-api-key', apiKey);

    expect(response.status).toBe(401);
    expect(response.body.status).toEqual('fail');
    expect(response.body.message).toEqual('Unauthorized. Need access token.');
  });

  it('harus berhasil mendapatkan arsip PDF dan gambar ketika semua permintaan wajib server terpenuhi', async () => {
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
});

// ---------- PATCH /archives/:id ----------

const newPDFArchiveTitle = 'Arsip PDF Baru';
const newImagesArchiveTitle = 'Arsip Gambar Baru';

describe('PATCH /archives/:id (Memperbarui Satu Arsip)', () => {
  it('harus gagal ketika tidak melampirkan kunci API pada header', async () => {
    const response = await request(app).patch(`/archives/${wrongArchiveId}`);

    expect(response.status).toBe(401);
    expect(response.body.status).toEqual('fail');
    expect(response.body.message).toEqual('API key is invalid.');
  });

  it('harus gagal ketika tidak melampirkan access token pada header', async () => {
    const response = await request(app)
      .patch(`/archives/${wrongArchiveId}`)
      .set('x-api-key', apiKey);

    expect(response.status).toBe(401);
    expect(response.body.status).toEqual('fail');
    expect(response.body.message).toEqual('Unauthorized. Need access token.');
  });

  it('harus gagal ketika ID arsip tidak ditemukan', async () => {
    const response = await request(app)
      .patch(`/archives/${wrongArchiveId}`)
      .set('x-api-key', apiKey)
      .set('Authorization', `Bearer ${accessToken}`);

    expect(response.status).toBe(400);
    expect(response.body.status).toEqual('fail');
    expect(response.body.message).toEqual('Validation error.');
    expect(response.body.validationErrors[0].path).toEqual('id');
    expect(response.body.validationErrors[0].msg).toEqual('Archive not found.');
  });

  it('harus berhasil memperbarui judul arsip PDF ketika semua permintaan wajib server terpenuhi', async () => {
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

  it('harus berhasil memperbarui judul arsip gambar ketika semua permintaan wajib server terpenuhi', async () => {
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
});

// ---------- GET /archives/semantic-search ----------

const query = 'apa itu rri palembang?';

describe('GET /archives/semantic-search (Mendapatkan Pencarian Semantik Arsip)', () => {
  it('harus gagal ketika tidak melampirkan kunci API pada header', async () => {
    const response = await request(app).get(`/archives/semantic-search`);

    expect(response.status).toBe(401);
    expect(response.body.status).toEqual('fail');
    expect(response.body.message).toEqual('API key is invalid.');
  });

  it('harus gagal ketika tidak melampirkan access token pada header', async () => {
    const response = await request(app)
      .get(`/archives/semantic-search`)
      .set('x-api-key', apiKey);

    expect(response.status).toBe(401);
    expect(response.body.status).toEqual('fail');
    expect(response.body.message).toEqual('Unauthorized. Need access token.');
  });

  it('harus gagal ketika tidak melampirkan kueri', async () => {
    const response = await request(app)
      .get(`/archives/semantic-search`)
      .set('x-api-key', apiKey)
      .set('Authorization', `Bearer ${accessToken}`);

    expect(response.status).toBe(400);
    expect(response.body.status).toEqual('fail');
    expect(response.body.message).toEqual('Validation error.');
    expect(response.body.validationErrors[0].path).toEqual('query');
    expect(response.body.validationErrors[0].msg).toEqual('Query is required.');
  });

  it(
    'harus berhasil mendapatkan respons AI serta arsip PDF dan gambar ketika semua permintaan wajib server terpenuhi',
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
  ); // Timeout 10 minutes
});

// ---------- DELETE /archives/:id ----------

describe('DELETE /archives/:id (Menghapus Satu Arsip)', () => {
  it('harus gagal ketika tidak melampirkan kunci API pada header', async () => {
    const response = await request(app).delete(`/archives/${wrongArchiveId}`);

    expect(response.status).toBe(401);
    expect(response.body.status).toEqual('fail');
    expect(response.body.message).toEqual('API key is invalid.');
  });

  it('harus gagal ketika tidak melampirkan access token pada header', async () => {
    const response = await request(app)
      .delete(`/archives/${wrongArchiveId}`)
      .set('x-api-key', apiKey);

    expect(response.status).toBe(401);
    expect(response.body.status).toEqual('fail');
    expect(response.body.message).toEqual('Unauthorized. Need access token.');
  });

  it('harus gagal ketika ID arsip tidak ditemukan', async () => {
    const response = await request(app)
      .delete(`/archives/${wrongArchiveId}`)
      .set('x-api-key', apiKey)
      .set('Authorization', `Bearer ${accessToken}`);

    expect(response.status).toBe(400);
    expect(response.body.status).toEqual('fail');
    expect(response.body.message).toEqual('Validation error.');
    expect(response.body.validationErrors[0].path).toEqual('id');
    expect(response.body.validationErrors[0].msg).toEqual('Archive not found.');
  });

  it(
    'harus berhasil menghapus arsip PDF ketika semua permintaan wajib server terpenuhi',
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
    'harus berhasil menghapus arsip gambar ketika semua permintaan wajib server terpenuhi',
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
});
