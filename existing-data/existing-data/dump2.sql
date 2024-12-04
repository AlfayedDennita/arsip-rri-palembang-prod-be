--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: enum_archive_files_extension; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_archive_files_extension AS ENUM (
    'pdf',
    'jpg',
    'jpeg',
    'png'
);


ALTER TYPE public.enum_archive_files_extension OWNER TO postgres;

--
-- Name: enum_archives_retention_category; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_archives_retention_category AS ENUM (
    'vital',
    'important',
    'useful',
    'temporary'
);


ALTER TYPE public.enum_archives_retention_category OWNER TO postgres;

--
-- Name: enum_users_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_users_role AS ENUM (
    'root',
    'admin',
    'leader',
    'staff'
);


ALTER TYPE public.enum_users_role OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: archive_codes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.archive_codes (
    id uuid NOT NULL,
    code character varying(50) NOT NULL,
    description character varying(512) DEFAULT ''::character varying,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    scope_id uuid NOT NULL
);


ALTER TABLE public.archive_codes OWNER TO postgres;

--
-- Name: archive_files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.archive_files (
    id uuid NOT NULL,
    page integer NOT NULL,
    extension public.enum_archive_files_extension NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    archive_id uuid NOT NULL
);


ALTER TABLE public.archive_files OWNER TO postgres;

--
-- Name: archives; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.archives (
    id uuid NOT NULL,
    title character varying(255) NOT NULL,
    published_at timestamp with time zone,
    retention_category public.enum_archives_retention_category NOT NULL,
    removed_at timestamp with time zone,
    description character varying(512) DEFAULT ''::character varying,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_by uuid,
    archive_code_id uuid NOT NULL
);


ALTER TABLE public.archives OWNER TO postgres;

--
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refresh_tokens (
    id uuid NOT NULL,
    token character varying(512) NOT NULL,
    last_accessed_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    user_id uuid NOT NULL
);


ALTER TABLE public.refresh_tokens OWNER TO postgres;

--
-- Name: reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reports (
    id uuid NOT NULL,
    title character varying(255) NOT NULL,
    description character varying(512) DEFAULT ''::character varying,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_by uuid,
    scope_id uuid NOT NULL
);


ALTER TABLE public.reports OWNER TO postgres;

--
-- Name: reset_password_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reset_password_requests (
    id uuid NOT NULL,
    expired_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    user_id uuid NOT NULL
);


ALTER TABLE public.reset_password_requests OWNER TO postgres;

--
-- Name: scopes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scopes (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    level smallint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    ancestor_id uuid
);


ALTER TABLE public.scopes OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(72) NOT NULL,
    role public.enum_users_role NOT NULL,
    name character varying(255) DEFAULT ''::character varying,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    scope_id uuid NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Data for Name: archive_codes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.archive_codes (id, code, description, created_at, updated_at, scope_id) FROM stdin;
65428c63-560b-4e26-8777-e384a8575480	PW.01.01	Pemantauan	2024-10-02 09:43:29.079+07	2024-10-02 09:43:29.079+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
1bcbc313-de17-4ad6-859d-5d123752d156	PW.01.02	Analisis	2024-10-02 09:43:47.183+07	2024-10-02 09:43:47.183+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
a70d2d66-2715-440d-9fb4-2465d7c0a450	PW.01.03	Evaluasi	2024-10-02 09:44:05.046+07	2024-10-02 09:44:05.046+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
1f7c3203-16f3-4c19-a157-4086033bf0b1	PW.01.04	Pelaporan	2024-10-02 09:44:35.707+07	2024-10-02 09:44:35.707+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
3f4f7291-2a23-45ea-bf5e-2848e57014b9	PW.01.05	LHKPN	2024-10-02 09:44:49.801+07	2024-10-02 09:44:49.801+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e4265540-5c77-4847-a0e8-340f0e8bcf90	PW.01.06	Gratifikasi	2024-10-02 09:45:35.507+07	2024-10-02 09:45:35.507+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
f4574af4-7351-4695-8f80-64d6e64ed911	PW.01.07	Pelaksanaan Pengawasan Internal dan Eksternal	2024-10-02 09:46:08.45+07	2024-10-02 09:46:08.45+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
55a275e2-03a1-46f6-9293-1e40e25aecf7	PW.01.08	Pelaksanaan Pengawasan Lainnya	2024-10-02 09:46:58.678+07	2024-10-02 09:46:58.678+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
7aa3ac4e-0da2-4e2b-a8f8-2d43aea71b78	PW.02	TINDAK LANJUT HASIL PENGAWASAN INTERNAL\nMeliputi naskah-naskah yang berkaitan dengan, dan	2024-10-02 09:47:46.359+07	2024-10-02 09:47:46.359+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
0fb604d1-4d54-41d7-8b4f-9d26244f3ff0	PW.02.01	Penyiapan Bahan Evaluasi Atas Laporan hasil pengawasan Aparat Pengawasan Internal Pemerintah	2024-10-02 09:48:32.873+07	2024-10-02 09:48:32.873+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
3464482d-49b2-4db8-8e4a-96fef1d7bdda	PW.02.02	Pengawasan Masyarakat/Publik	2024-10-02 09:49:03.32+07	2024-10-02 09:49:03.32+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
80667c63-2ff8-42e6-88ed-4a906c9ba388	PW.02.03	Pemantauan Penyelesaian Tindak Lanjut Hasil Pengawasan Internal dan Masyarakat/Publik	2024-10-02 09:49:41.273+07	2024-10-02 09:49:41.273+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
abf724d9-479f-4634-8bbf-00db9f200c7d	PW.03	TINDAK LANJUT HASIL PENGAWASAN EKSTERNAL	2024-10-02 09:50:07.743+07	2024-10-02 09:50:07.743+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
00c14218-ba30-44f0-ab6f-fef168ca3679	PW.03.01	Penyiapan Bahan Evaluasi Atas Laporan hasil pengawasan Aparat Pengawasan Internal Pemerintah	2024-10-02 09:51:01.403+07	2024-10-02 09:51:01.403+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
c7a967e9-0a2e-4250-9100-91cd71425df4	UM.01.08	Sumbangan/Bantuan	2024-10-02 09:58:05.278+07	2024-10-02 09:58:05.278+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
56c4551a-2118-4677-a6dd-5b155e5ce44b	UM.02.03	Penyusutan Arsip	2024-10-02 09:59:53.73+07	2024-10-02 09:59:53.73+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
df1ad1ff-77bf-46f8-ab0b-ce1abbb22bf4	KP	KEPEGAWAIAN	2024-10-02 10:00:44.14+07	2024-10-03 07:04:47.471+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
14ff7357-56f5-41b5-a6b7-59f0a305884f	UM	UMUM	2024-10-02 09:53:47.082+07	2024-10-03 07:17:09.181+07	77abd0a0-9b86-445a-ac6a-debc7276a9b8
87efb22a-1285-4af5-9d5b-5ad97c8d9b24	UM.01.02	Kebersihan, Ketertiban, dan Keamanan	2024-10-02 09:55:09.687+07	2024-10-03 07:17:58.592+07	77abd0a0-9b86-445a-ac6a-debc7276a9b8
43a49bbd-b261-4e96-9c78-e3bdb62437d4	UM.01	TATA USAHA DAN RUMAH TANGGA	2024-10-02 09:54:09.647+07	2024-10-03 07:18:49.457+07	77abd0a0-9b86-445a-ac6a-debc7276a9b8
b57e817d-6797-4519-85f9-817d49374497	UM.01.01	Administrasi Persuratan	2024-10-02 09:54:31.489+07	2024-10-03 07:19:13.918+07	77abd0a0-9b86-445a-ac6a-debc7276a9b8
38c37b76-a7b3-47de-985c-67616d868e38	UM.01.03	Izin Penyewaan/Peminjaman (Alat-alat, Ruangan, Lapangan, dll)	2024-10-02 09:55:46.903+07	2024-10-03 07:19:49.375+07	77abd0a0-9b86-445a-ac6a-debc7276a9b8
5c4e3097-72cb-44a8-9bce-39c996bcf889	UM.02.05	Pembinaan Kearsipan	2024-10-02 10:00:32.96+07	2024-10-03 07:22:01.294+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
453377f7-4c48-4ea1-8a5a-17db6eb6859d	KP.01.04	Pendaftaran/Keluarga/Perkawinan/Anak/Karis/Karsu	2024-10-02 10:03:12.749+07	2024-10-03 07:45:26.475+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
08c655c8-8c9a-4c3e-a12b-67f700e16281	KP.01.03	Penggajian/KGB/Tunjangan Jabatan/Daftar Gaji	2024-10-02 10:02:37.414+07	2024-10-03 07:47:02.54+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
2b601b3a-13ef-4560-9909-f8de055a8936	KP.01.02	NIP/Kartu Pegawai/Kartu PPNS/Tanda Pengenal	2024-10-02 10:02:10.976+07	2024-10-03 07:47:33.083+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
3de70f47-f752-4578-b1d9-a445fb8cb355	KP.01.01	Data Perorangan/Status/Database/DRH/Statistik	2024-10-02 10:01:37.385+07	2024-10-03 07:48:05.364+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
96863a54-ebfb-447c-be97-f0bd1ffdadd3	KP.01	TATA USAHA KEPEGAWAIAN	2024-10-02 10:01:03.298+07	2024-10-03 07:48:53.802+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
809e25f5-3e66-4413-9ef4-085dd108794e	UM.02.04	Berkas Proses Alih Media Arsip	2024-10-02 10:00:14.46+07	2024-10-03 07:51:26.505+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
b86d6fc4-961b-4ef7-a604-0f847886792e	KP.01.15	Izin Kerja/Izin Belajar/Izin Dispensasi	2024-10-02 10:08:41.102+07	2024-10-03 07:51:50.086+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
fdc49924-3ede-48fd-8954-2ac1b791d02e	KP.01.14	Absensi	2024-10-02 10:08:04.439+07	2024-10-03 07:52:14.903+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
a7310eb7-329c-4ca4-8878-3d9bc3badd5b	KP.01.13	Surat Kuasa	2024-10-02 10:07:40.536+07	2024-10-03 07:52:40.701+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
049ab9fc-1207-4701-b0a0-9c089f31ebf1	KP.01.12	Pelaporan Nikah/Cerai/Rujuk/Izin Perkawinan	2024-10-02 10:07:22.205+07	2024-10-03 07:53:06.378+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
7b76bc6d-411d-4b80-8346-0693d5d7160f	KP.01.11	Cuti	2024-10-02 10:06:53.505+07	2024-10-03 07:53:38.576+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
a1b64e3f-ff68-4df3-9e58-a3e2441d647d	KP.01.10	Daftar Kepangkatan/DUK	2024-10-02 10:06:37.086+07	2024-10-03 07:54:05.72+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
40b0d022-90a9-4700-ba87-5707820d8942	KP.01.09	Sumpah Pegawai	2024-10-02 10:06:14.179+07	2024-10-03 07:55:07.32+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
1dfd4424-a119-42dc-9a7b-9efc08753afa	KP.01.08	Pendelegasiann Wewenang	2024-10-02 10:05:57.018+07	2024-10-03 07:55:35.639+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
c2c3246d-11e6-4977-91e4-118349f57985	KP.01.07	Penghargaan/Piala/Piagam/Tanda Kehormatan	2024-10-02 10:05:35.444+07	2024-10-03 07:56:05.501+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
aea738d2-7a3a-4be1-8841-0c9563eb24e1	KP.01.06	Penugasan/Penunjukan/Surat Perintah/Pemanggilan/PLH/Surat Pernyataan/Surat Keterangan/SPMT	2024-10-02 10:04:49.793+07	2024-10-03 07:56:35.811+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
7525033c-ec4f-4630-9c0d-d70f475c4194	PR.02	Pelaporan	2024-10-02 09:36:02.862+07	2024-10-08 13:25:36.411+07	c7e59b55-f135-4de4-ad4f-ea8d26e76574
3c016d1f-00e1-4852-8258-1a6a21aaff46	PR.01.01	Perencanaan Kegiatan	2024-10-02 09:28:47.018+07	2024-10-08 13:26:22.204+07	c7e59b55-f135-4de4-ad4f-ea8d26e76574
76abbb25-8119-4a7d-80ac-a67227024bc0	PR.01.02	Penyusunan Anggaran	2024-10-02 09:29:19.039+07	2024-10-08 13:27:08.983+07	c7e59b55-f135-4de4-ad4f-ea8d26e76574
928e6b9d-1dba-42c1-953e-1785dc1926b3	PR.01.03	Analisis Program	2024-10-02 09:30:38.751+07	2024-10-08 13:27:40.582+07	c7e59b55-f135-4de4-ad4f-ea8d26e76574
5432952b-83e1-40ca-b5b9-b418097382a2	PR.02.01	Pelaporan Anggaran dan Kinerja	2024-10-02 09:33:40.477+07	2024-10-08 13:28:06.581+07	c7e59b55-f135-4de4-ad4f-ea8d26e76574
6f29b75d-d363-4a76-ba42-3c08899e66fc	PR.01	Rencana dan Program ( Terkait kegiatan Anggaran dari setiap Unit)	2024-10-02 09:35:20.376+07	2024-10-09 09:38:30.695+07	c7e59b55-f135-4de4-ad4f-ea8d26e76574
1dc15b64-601b-447c-aff5-dfe2188eb42a	PR.02.02	Pelaksanaan Anggaran	2024-10-02 09:37:26.788+07	2024-10-09 09:39:24.436+07	c7e59b55-f135-4de4-ad4f-ea8d26e76574
e9748adc-40af-4003-9623-7b7c9fdcb816	PR.02.04	Akuntabilitas Kinerja Instansi Pemerintah (LAKIP)	2024-10-02 09:39:26.316+07	2024-10-09 09:40:45.572+07	c7e59b55-f135-4de4-ad4f-ea8d26e76574
41b5f6df-5d73-4cca-bf64-156a7ce5d585	PR.03	EVALUASI\nMeliputi naskah-naskah yang berkaitan dengan evaluasi perencanaan kegiatan, evaluasi penyusunan anggaran, evaluasi analisis program.	2024-10-02 09:40:51.212+07	2024-10-09 09:41:28.024+07	c7e59b55-f135-4de4-ad4f-ea8d26e76574
f2a12d77-908c-452b-baab-a83b60c3dbf5	PR.03.01	Evaluasi Perencanaan Kegiatan	2024-10-02 09:41:18.315+07	2024-10-09 09:42:52.566+07	c7e59b55-f135-4de4-ad4f-ea8d26e76574
62cf61ec-81ac-488c-bec9-fbb136899197	PR.03.02	Evaluasi Perencanaan Anggaran	2024-10-02 09:41:41.796+07	2024-10-09 09:43:35.252+07	c7e59b55-f135-4de4-ad4f-ea8d26e76574
d516c029-9d38-49c1-aa91-a669c892bc41	PR.03.03	Evaluasi Analisis Program	2024-10-02 09:42:13.926+07	2024-10-09 09:44:18.127+07	c7e59b55-f135-4de4-ad4f-ea8d26e76574
879f5eb4-02d0-4afd-a39b-a7ed00d064d0	PW	Pengawasan	2024-10-02 09:42:39.896+07	2024-10-09 09:45:01.395+07	c7e59b55-f135-4de4-ad4f-ea8d26e76574
52de8542-2c85-4449-971c-e0f202b0ec30	PW.01	Hasil Pengawasan/LHKPN/Gratifikasi	2024-10-02 09:43:13.936+07	2024-10-09 09:45:42.671+07	c7e59b55-f135-4de4-ad4f-ea8d26e76574
d23f86b7-d2ff-482c-a547-44a3114fbd07	PR	PERENCANAAN	2024-10-02 09:53:31.491+07	2024-10-09 10:06:50.235+07	77abd0a0-9b86-445a-ac6a-debc7276a9b8
2c4b1878-b175-4895-a5b0-4fdc3504b770	PW.03.03	Pemantauan Penyelesaian Tindak Lanjut Hasil Pengawasan Internal dan Masyarakat/Publik	2024-10-02 09:52:15.884+07	2024-10-09 10:10:59.38+07	af381477-1123-4852-9c32-1f542bfaf7b6
8c902169-261c-4060-a288-dac2d705e79f	PW.03.02	Pengawasan Masyarakat/Publik	2024-10-02 09:51:39.751+07	2024-10-09 10:11:45.502+07	af381477-1123-4852-9c32-1f542bfaf7b6
977af9cb-322a-44f4-9e7c-4b2071be6d77	UM.01.04	Perumahan Dinas/Kendaraan Dinas	2024-10-02 09:56:07.926+07	2024-10-09 10:13:26.136+07	77abd0a0-9b86-445a-ac6a-debc7276a9b8
1f5f54ad-c3d8-4e06-b8f2-6f49cf2b1ce1	UM.01.05	Gedung/Perkantoran/Gudang	2024-10-02 09:56:30.984+07	2024-10-09 10:14:24.883+07	77abd0a0-9b86-445a-ac6a-debc7276a9b8
4a4b26f2-2761-4eb8-b9b7-3358187c5ca7	UM.01.06	Pakaian Dinas	2024-10-02 09:56:54.178+07	2024-10-09 10:15:21.501+07	77abd0a0-9b86-445a-ac6a-debc7276a9b8
d83ca8f9-e912-4a3f-9ad2-e8c8a4fff69b	UM.01.07	Listrik/PAM/Telepon/AC	2024-10-02 09:57:23.065+07	2024-10-17 14:59:23.743+07	77abd0a0-9b86-445a-ac6a-debc7276a9b8
2398bbe5-52ef-4b90-aac8-6c217f136c51	UM.02	KEARSIPAN	2024-10-02 09:58:23.652+07	2024-10-17 15:02:51.032+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
f49b56c1-d029-4517-8d74-1f0ef48d8927	UM.02.01	Penyimpanan dan Pemeliharaan Arsip	2024-10-02 09:58:49.374+07	2024-10-17 15:03:54.14+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
01a1c9f0-8ede-428c-88b1-de0ac972becd	UM.02.02	Layanan Arsip (Peminjaman dan Penggunaan Arsip)	2024-10-02 09:59:33.185+07	2024-10-17 15:06:14.729+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
54d30c7c-1987-4841-9136-b41ea42a696d	KP.01.16	Uji Kesehatan	2024-10-02 10:08:59.711+07	2024-10-17 15:11:53.761+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
6b6dfdad-4149-4880-ada0-baabb5a207c2	KP.02	PERENCANAAN PEGAWAI	2024-10-02 10:09:36.976+07	2024-10-02 10:09:36.976+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
c013f3d5-be0a-4cb3-ab02-d5ef6c5394b9	KP.02.01	Analisis Jabatan	2024-10-02 10:09:57.664+07	2024-10-02 10:09:57.664+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
9cbdfd00-e986-4cbe-a94e-bc42e54981b6	KP.02.02	Formasi Pegawai	2024-10-02 10:10:12.362+07	2024-10-02 10:10:12.362+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
a40a2b8a-a3cd-449a-8a01-cad42764d139	KP.02.03	Peta Jabatan	2024-10-02 10:10:27.877+07	2024-10-02 10:10:27.877+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
649a8788-5d59-47ca-9228-af620798df95	KP.03	PENGADAAN PEGAWAI	2024-10-02 10:10:44.66+07	2024-10-02 10:10:44.66+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
3f6cf34e-6520-497a-b7b8-4a7148b9ec5a	KP.03.01	Seleksi Pegawai	2024-10-02 10:11:01.74+07	2024-10-02 10:11:01.74+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
0ad64030-66af-4920-8c8b-d0fb87f65d20	KP.03.02	Penempatan Pegawai	2024-10-02 10:11:23.423+07	2024-10-02 10:11:23.423+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
028b1aab-7e2e-4bec-80ec-56823995e882	KP.03.03	Pengangkatan dan Pengunduran Diri CPNS	2024-10-02 10:11:45.272+07	2024-10-02 10:11:45.272+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d7afcf93-5c75-4754-8494-b8074320f438	KP.03.04	Pengangkatan PNS	2024-10-02 10:12:00.31+07	2024-10-02 10:12:00.31+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
b3bc487f-e054-463f-a933-35bd90e25c93	KP.04	\nMUTASI PEGAWAI	2024-10-02 10:12:18.258+07	2024-10-02 10:12:18.258+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
51339d5e-1e0b-41b4-ac72-2503af6f3c6b	KP.04.01	Pemindahan PNS/Non PNS Antar Unit	2024-10-02 10:12:43.486+07	2024-10-02 10:12:43.486+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
f83b13bd-650d-4a53-9b61-64287b0fc7d3	KP.04.02	Pemindahan PNS/Non PNs antar Instansi	2024-10-02 10:13:10.276+07	2024-10-02 10:13:10.276+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
0513d5d1-bc06-4f31-b402-588a6b7d4230	KP.04.03	Pemindahan PNS/Non PNS dengan Status Dipekerjakan/Diperbantukan	2024-10-02 10:13:54.572+07	2024-10-02 10:13:54.572+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
faff0696-91e8-46e3-832c-668c8d06cc41	KP.04.04	Kenaikan Pangkat Struktural dan fungsional	2024-10-02 10:14:23.485+07	2024-10-02 10:14:23.485+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
2c42d34d-13b5-43cc-8254-d37a7fcffee9	KP.04.05	Mutasi pendidikan	2024-10-02 10:14:41.59+07	2024-10-02 10:14:41.59+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
91ce3908-1c9a-49ea-a91e-8cff952b5455	KP.04.06	Pengangkatan, pemindahan, dan pemberhentian dalam jabatan struktural	2024-10-02 10:15:15.425+07	2024-10-02 10:15:15.425+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d85d1bce-da05-42e4-8c51-b37afd4ddea7	KP.04.07	Pengangkatan, pemindahan, pemberhentian dan pembebasan sementara dalam jabatan struktural	2024-10-02 10:15:51.972+07	2024-10-02 10:15:51.972+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
a9a128cb-fe6e-43e7-a0d9-d2882c81a940	KP.04.08	Impasing / penyesuaian ijazah	2024-10-02 10:16:17.577+07	2024-10-02 10:16:17.577+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
55b15865-ba2a-49fd-90e1-3b874f6eb232	KP.04.09	Serah terima jabatan/tugas	2024-10-02 10:16:35.383+07	2024-10-02 10:16:35.383+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d3a60c06-9bd4-4b40-9c16-43564897947c	KP.05	PEMBINAAN KARIR PEGAWAI	2024-10-02 10:16:54.58+07	2024-10-02 10:16:54.58+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
144a462e-8cca-46ba-afb0-93cfcb36f2a5	KP.05.01	Tata usaha kediklatan (kurikulum, modul, dokumen administrasi, dokumen akademik, dokumen evaluasi, sertifikat/STTPL)	2024-10-02 10:18:10.489+07	2024-10-02 10:18:10.489+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
380e3c14-d468-4bb7-976a-4f5ff81338fa	KP.05.02	Pembinaan mental	2024-10-02 10:18:26.302+07	2024-10-02 10:18:26.302+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
62737cd4-6383-4f95-9d87-ce72090e59c2	KP.05.03	Diklat prajabatan	2024-10-02 10:18:49.749+07	2024-10-02 10:18:49.749+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
6440b4fc-b43c-440c-90cb-96b1ace6c4b5	KP.05.04	Diklat pimpinan	2024-10-02 10:19:05.027+07	2024-10-02 10:19:05.027+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
0d628238-932f-4cf9-b699-a9d7aa524af8	KP.05.05	Diklat Fungsional	2024-10-02 10:19:21.244+07	2024-10-02 10:19:21.244+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
397d4ff8-2fa7-454f-92f7-35783674e852	KP.05.06	Diklat teknis	2024-10-02 10:19:35.619+07	2024-10-02 10:19:35.619+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
1749e328-7385-4c49-b5b5-33b15b98078c	KP.06	PENILAIAN PEGAWAI	2024-10-02 10:19:50.899+07	2024-10-02 10:19:50.899+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d97b9f42-2af3-48a7-85ff-68ca1b3f3825	KP.06.01	Assesment pegawai	2024-10-02 10:20:05.638+07	2024-10-02 10:20:05.638+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
f46b2be4-2480-4347-a78b-6f8ef2d2ba19	KP.06.02	Ujian Dinas, Ujian Penyesuaian Ijazah	2024-10-02 10:21:00.856+07	2024-10-02 10:21:00.856+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
c4a165c4-a574-4961-80d9-7c63e2d12b69	KP.06.03	Teguran/Peringatan/Penundaan gaji dan pangkat/penurunan pangkat	2024-10-02 10:21:39.582+07	2024-10-02 10:21:39.582+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
a89abf0e-6664-46fb-84df-ba01523e0c84	KP.06.04	Skorsing/hukuman jabatan	2024-10-02 10:21:56.789+07	2024-10-02 10:21:56.789+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
59e7a84a-ae06-47c5-a415-c4e3e88a0770	KP.06.05	Rehabilitasi/permohonan kerja kembali	2024-10-02 10:22:27.135+07	2024-10-02 10:22:27.135+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e79fef13-2082-4637-b2fd-03414f80b4af	KP.06.06	Jam kerja/disiplin	2024-10-02 10:22:45.554+07	2024-10-02 10:22:45.554+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
33bd3a0e-15dc-4764-87d2-d459e0023cbb	KP.06.07	DP3/SKP	2024-10-02 10:23:01.189+07	2024-10-02 10:23:01.189+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
7a574743-bccd-4fd5-96be-4b58d4785165	KP.06.08	Angka kredit jabatan fungsional	2024-10-02 10:23:22.92+07	2024-10-02 10:23:22.92+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
df7a66ad-7d13-47f8-9625-3784033a4dca	KP.07	KESEJAHTERAAN PEGAWAI	2024-10-02 10:23:44.308+07	2024-10-02 10:23:44.308+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
db086691-a0f2-42f9-a6f6-b088e37013b2	KP.07.01	Kesehatan klinik	2024-10-02 10:24:03.057+07	2024-10-02 10:24:03.057+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d8443c99-2ea8-4362-a918-430010af388a	KP.07.02	Taspen/akses/jasmostek/bapertarum	2024-10-02 10:24:29.56+07	2024-10-02 10:24:41.057+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
7f3fd493-82e1-4c76-9288-b694b4a76c43	KP.07.03	Olahraga/kesenian dan budaya	2024-10-02 10:25:05.675+07	2024-10-02 10:25:05.675+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
9215b285-d7d8-4d6d-be62-718b0d0fc86f	KP.08	PEMBERHENTIAN DAN PENSIUN	2024-10-02 10:25:59.467+07	2024-10-02 10:25:59.467+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
768902b8-c110-432f-b580-f404328e077d	KP.08.01	Pemberhentian dengan hormat/mengundurkan diri	2024-10-02 10:26:52.333+07	2024-10-02 10:26:52.333+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
4b4a2475-4277-48fb-8ada-70e99172b797	KP.08.02	Pemberhentian dengan tidak hormat	2024-10-02 10:27:06.825+07	2024-10-02 10:27:06.825+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
9daebd08-ceac-439a-ae9b-cd5cab1d1475	KP.08.03	Masa persiapan pensiun (MPP) / pembekalan pensiun	2024-10-02 10:27:35.199+07	2024-10-02 10:27:35.199+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
700e4fde-eb31-409b-9cc5-4cea829a2556	KP.08.04	Penetapan uang pensiun/pesangon	2024-10-02 10:28:00.778+07	2024-10-02 10:28:00.778+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
11a44b7d-a5f2-41b3-91f7-9cd7e8ac5238	KP.08.05	Pensiun (BUP)	2024-10-02 10:28:24.772+07	2024-10-02 10:28:24.772+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
0c5215b0-6078-489a-bc96-c4231fae68ae	KP.08.06	Pensiun janda/duda/anak	2024-10-02 10:29:21.938+07	2024-10-02 10:29:21.938+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
0c182d18-9509-4152-846d-df9155f9f103	KP.08.07	Pensiun meninggal dunia/tewas	2024-10-02 10:29:56.148+07	2024-10-02 10:29:56.148+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
b9591f8e-1e2e-4b7a-b188-5a06998d105b	KP.08.08	Nominatif pensiun	2024-10-02 10:30:13.855+07	2024-10-02 10:30:13.855+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
17525691-d333-477a-97a4-147bc253eacc	KP.09	PERKUMPULAN PEGAWAI/NON PEGAWAI	2024-10-02 10:30:34.407+07	2024-10-02 10:30:34.407+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
b9e16162-33b7-4777-b9c8-8cbf573c1534	KP.09.01	KORPRI	2024-10-02 10:30:59.365+07	2024-10-02 10:30:59.365+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
c3fbe8c9-7d04-479d-abff-b713c6a7c0df	KP.09.02	Dharma wanita	2024-10-02 10:31:18.426+07	2024-10-02 10:31:18.426+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
6009cb5b-b1fe-427d-8f77-35b8cb6e3cf9	KP.09.03	Koperasi	2024-10-02 10:31:34.389+07	2024-10-02 10:31:34.389+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
c92c0a10-556d-47fe-a68f-58f200efd8b9	KP.09.04	Organisasi lainnya	2024-10-02 10:31:48.322+07	2024-10-02 10:31:48.322+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
ffccf613-c6ae-45d6-8adf-4f8a7d6d5de5	KU	KEUANGAN	2024-10-02 10:31:59.505+07	2024-10-02 10:31:59.505+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
1e27eba6-20cd-49bd-a868-73f6967a33b3	KU.01	ANGGARAN	2024-10-02 10:32:14.339+07	2024-10-02 10:32:14.339+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
a508a62f-cf3e-473d-ad42-260136f77507	KU.01.01	DIPA (Rincian RKA-KL, Petunjuk Operasional (PO), Pergeseran/Perubahan/Revisi DIPA dan PO DIP, APBN)	2024-10-02 10:33:18.736+07	2024-10-02 10:33:18.736+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
9e3eaf4d-ab6b-4955-8e60-edb7e428e4fd	KU.01.02	ABT (Anggaran Belanja Tambahan)	2024-10-02 10:33:38.951+07	2024-10-02 10:33:38.951+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
578f3ece-20ca-4e1f-a350-00ea9cfcd97e	KU.01.03	Berita acara, kontrak/SPK	2024-10-02 10:33:58.349+07	2024-10-02 10:33:58.349+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
6e83e6ce-8524-4820-b19a-0f60ed37bc28	KU.01.04	SPPD	2024-10-02 10:34:13.761+07	2024-10-02 10:34:13.761+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
b5c92011-5659-4e5c-b69b-3d301394cd89	KU.01.05	SPP/Surat Permintaan Pembayaran (Belanja Pegawai, belanja barang, belanja modal, belanja lain-lain)	2024-10-02 10:35:14.012+07	2024-10-02 10:35:14.012+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
a52e3bfa-d07b-4de1-a112-1952df6b7ab9	KU.01.06	SP2D(Surat Perintah Pencairan Dana)	2024-10-02 10:35:57.162+07	2024-10-02 10:35:57.162+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
c3b1fdfd-a6da-43b2-9e3a-e618a31f73d7	KU.01.07	Neraca (semesteran,tahunan	2024-10-02 10:36:23.568+07	2024-10-02 10:36:23.568+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
a75b8b23-c9c1-44b0-b6c8-6b2a45891ba4	KU.01.08	Daftar uang makan/uang lebur/remunerasi/honor	2024-10-02 10:37:04.153+07	2024-10-02 10:37:04.153+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
1eec4fd2-cc83-4e26-a26e-f64f5041fe3d	KU.02	BANTUAN DAN PINJAMAN LUAR NEGERI\n	2024-10-02 10:37:22.805+07	2024-10-02 10:37:22.805+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
b637ec07-9e49-4974-a925-14e66b5289d1	KU.02.01	Loan Agreement/hibah luar negeri	2024-10-02 10:37:50.323+07	2024-10-02 10:37:50.323+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
64fa1582-65a2-40ab-9239-0058ad0137e4	KU.02.02	Ikhtisar kegiatan	2024-10-02 10:38:06.84+07	2024-10-02 10:38:06.84+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d5ed2d92-af45-4537-8ca6-ca8f5c86987d	KU.02.03	Kerangka acuan kerja	2024-10-02 10:38:24.952+07	2024-10-02 10:38:24.952+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e9ae8179-7288-4ba4-b0d3-d227034fc627	KU.02.04	Studi kelayakan	2024-10-02 10:38:39.763+07	2024-10-02 10:38:39.763+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
a0a96f69-8d91-4e4b-b31a-fbb71413941b	KU.02.05	Rincian Anggaran Biaya (RAB)	2024-10-02 10:38:59.443+07	2024-10-02 10:38:59.443+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
2090b9ce-cdd6-4741-b5c8-5c984ea799cf	KU.02.06	Dokumen kontrak	2024-10-02 10:39:13.826+07	2024-10-02 10:39:13.826+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
b7f3ac93-c8b4-426c-8850-496121e743fc	KU.02.07	Reimbursment kepada Negara/Badan Pemberian Bantuan	2024-10-02 10:39:46.295+07	2024-10-02 10:39:46.295+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
11a88aff-f399-4b5c-8af6-44993afd12be	KU.02.08	SPP/SPM	2024-10-02 10:40:02.687+07	2024-10-02 10:40:02.687+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
b706f6d8-b549-44e0-a6df-bd237237d0eb	KU.02.09	Pembukaan LC (Letter of Credit)/Valuta asing/penerbitan/obligasi	2024-10-02 10:40:41.517+07	2024-10-02 10:40:41.517+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d9313442-ba5d-4c9d-9c11-6930530d1e11	KU.03	PENDAPATAN/PENERIMAAN	2024-10-02 10:40:59.081+07	2024-10-02 10:40:59.081+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d6593439-bd92-49fa-a390-c75eb67adf02	KU.03.01	Pajak-pajak	2024-10-02 10:41:20.389+07	2024-10-02 10:41:20.389+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
cea29e22-4092-4921-b1df-893726800e3a	KU.03.02	Pendapatan bukan pajak	2024-10-02 10:41:36.126+07	2024-10-02 10:41:36.126+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
8835bf4b-af97-443c-9c48-fa7819dac1d1	KU.03.03	Sewa pemanfaatan aset/barang milik negara	2024-10-02 10:42:04.736+07	2024-10-02 10:42:04.736+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
0b93c904-63b0-475e-847c-cd8ae5439926	KU.04	PERBENDAHARANAN/PEMBUKUAN/VERIFIKASI	2024-10-02 10:42:29.391+07	2024-10-02 10:42:29.391+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
badffccf-7e18-4f74-a736-caff69c415c6	KU.04.01	Tuntutan Perbendaharaan/Tuntutan Ganti Rugi (TP/TGR)	2024-10-02 10:43:16.695+07	2024-10-02 10:43:16.695+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
1f30ed61-fc71-4b8d-a8ea-618446f0e32a	KU.04.02	Tata Usaha Keuangan Negara	2024-10-02 10:44:14.817+07	2024-10-02 10:44:14.817+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
8dd99274-04e3-4e47-b7cc-26d616b56c66	KU.04.03	Pengelolaan Anggaran (Kuasa Pengguna Anggaran/KPA, Pejabat Pembuat Komitmen/PPK, Pejabat Penguji dan Penandatanganan SPM, Bendahara Pengeluaran, Bendarhara Penerimaan)	2024-10-02 10:45:33.177+07	2024-10-02 10:45:33.177+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
14deacbe-1dbb-4ddf-b049-a7a8e90c279e	KU.04.04	Rencana Kerja Anggaran(RKA)	2024-10-02 10:46:12.025+07	2024-10-02 10:46:12.025+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
7014dcca-a320-48ff-b2e2-15d9fadbc3ca	KU.04.05	Tagihan dinas	2024-10-02 10:46:27.065+07	2024-10-02 10:46:27.065+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
86331f39-9d80-4c59-af3a-354ea6687485	PL	PERLENGKAPAN	2024-10-02 10:46:40.553+07	2024-10-02 10:46:40.553+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
7d8247c1-a89b-454c-b05e-50d5fcf7fbd4	PL.01	ANALISIS	2024-10-02 10:46:56.512+07	2024-10-02 10:46:56.512+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
684760e2-340a-4b90-8090-5b8dd3d89c1f	PL.01.01	Analisis Data Perencanaan	2024-10-02 10:47:20.223+07	2024-10-02 10:47:20.223+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d2c85295-bd55-4b99-af53-95cb3a732cb8	PL.01.02	Klasifikasi Data	2024-10-02 10:47:38.034+07	2024-10-02 10:47:38.034+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
95f96965-0de0-45e3-b647-6bd8e9c7ae05	PL.01.03	Rencana Kebutuhan Pengadaan	2024-10-02 10:47:58.771+07	2024-10-02 10:47:58.771+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
7e76a2b2-f8da-4574-a8f1-2adf76fd8979	PL.01.04	Rencana Kebutuhan Pengadaan	2024-10-02 10:48:25.322+07	2024-10-02 10:48:25.322+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
be9f992e-b617-4646-a3ce-ffcb5cc3783e	PL.02	PENGADAAN	2024-10-02 10:48:52.268+07	2024-10-02 10:48:52.268+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
ce97e1d8-6252-46d8-9f0c-034e96755bd5	PL.02.01	Rekanan/Penawaran/Proposal/Brosur	2024-10-02 10:49:35.716+07	2024-10-02 10:49:35.716+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
20e17839-e88a-463b-b35e-a3462f4b152b	PL.02.02	Tender dan Kontrak/Prakualifikasi dan Pasca Kualifikasi, Penunjukan Pemenang, Sanggahan/Surat Kuasa Kontrak/Berita Acara	2024-10-02 10:50:37.575+07	2024-10-02 10:50:37.575+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
8ae25923-a610-4391-8350-d218cae118b2	PL.02.03	Harga dan Mutu	2024-10-02 10:51:02.644+07	2024-10-02 10:51:02.644+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
86ded28f-5ef4-44a5-bfe3-65fce238b4e4	PL.02.04	Pembelian	2024-10-02 10:51:18.756+07	2024-10-02 10:51:18.756+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
04b5590d-d057-4415-ab83-f79ca3ae5fbe	PL.03	PEMANFAATAN BARANG MILIK NEGARA	2024-10-02 10:51:41.585+07	2024-10-02 10:51:41.585+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d69a722b-bb93-4e94-a9ee-ac570c23e571	PL.03.01	Pembinaan BMN Perlengkapan	2024-10-02 10:51:59.234+07	2024-10-02 10:51:59.234+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
c10aebb7-27e7-4a0b-8c98-4349f7487dc1	PL.03.02	Distribusi/Pengiriman	2024-10-02 10:52:29.309+07	2024-10-02 10:52:29.309+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
421f3fd2-c016-4fad-bebc-67b89377ec74	PL.03.03	Pemeriksaan Pemanfaatan	2024-10-02 10:52:47.294+07	2024-10-02 10:52:47.294+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
8f6fe3b4-1ba0-45cf-8d6b-97917b51fc80	PL.03.04	Rehabilitasi/Pemulihan/Renovasi	2024-10-02 10:53:19.822+07	2024-10-02 10:53:19.822+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
afa7135f-d549-4965-b439-0d31a461fe4c	PL.03.05	Pergudangan/Penyimpanan	2024-10-02 10:53:49.949+07	2024-10-02 10:53:49.949+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
2fcaaf72-45b5-4477-bf7c-8eddde1a6cae	PL.03.06	Pemeliharaan BMN	2024-10-02 10:54:04.866+07	2024-10-02 10:54:04.866+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
7437ccd5-9881-49f3-9e0c-253654919a69	PL.04	INVENTARISASI DAN PELAPORAN BMN	2024-10-02 10:54:32.129+07	2024-10-02 10:54:32.129+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
687ed0c0-7de5-47d4-b686-7199586b03c6	PL.04.01	Inventarisasi Umum/Mutasi Barang/Serah Terima Aset/Berita Acara Hibah	2024-10-02 10:55:08.675+07	2024-10-02 10:55:08.675+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
0170e7e3-7cc1-48a8-870d-481c5299b64c	PL.04.02	Barang-barang Bergerak	2024-10-02 10:55:25.88+07	2024-10-02 10:55:25.88+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d43b0313-0aaa-4ca7-9ee6-5ce0137c7799	PL.04.03	Barang-barang tidak Bergerak	2024-10-02 10:55:40.414+07	2024-10-02 10:55:40.414+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
914ae2cd-d993-494d-9ed2-bd13fd9a1839	PL.04.04	Standarisasi/Kodefikasi	2024-10-02 10:56:11.149+07	2024-10-02 10:56:11.149+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
f1b8f663-f7c7-4e94-a978-9d6aee542e34	PL.04.05	Pelaporan Persediaan dan BMN	2024-10-02 10:56:30.282+07	2024-10-02 10:56:30.282+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
82d7598f-174f-4980-8bd0-7740d63386e1	PL.05	PENGHAPUSAN BMN	2024-10-02 10:56:43.451+07	2024-10-02 10:56:43.451+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
598a5a24-c8a4-444e-801a-6c46f92bb3bf	PL.05.01	Standarisasi/Petunjuk Teknis Penghapusan	2024-10-02 10:57:11.2+07	2024-10-02 10:57:11.2+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
813800b4-d2a5-4cc4-846f-7a6cb45dd88e	PL.05.02	Usul Penghapusan dan Data Pendukung\n	2024-10-02 10:57:37.535+07	2024-10-02 10:57:37.535+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
c755e84c-5f4a-4c60-9139-ace1c81889ad	PL.05.03	Penilaian	2024-10-02 10:57:50.875+07	2024-10-02 10:57:50.875+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
dc1f0c12-ad88-4b86-b34f-34598dc6f04b	PL.05.04	Penetapan Penghapusan	2024-10-02 10:58:13.005+07	2024-10-02 10:58:13.005+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e4923695-59f1-4c36-a5fc-2e9fedebe7b1	PL.05.05	Pelelangan/Penjualan	2024-10-02 10:58:30.559+07	2024-10-02 10:58:30.559+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
a5b11002-b78c-422f-89e7-834ac60958a5	PL.05.06	Tukar Guling/Ruislag	2024-10-02 10:58:48.355+07	2024-10-02 10:58:48.355+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
22445653-24d5-4a8c-a01d-4358402df623	HK	HUKUM	2024-10-02 10:58:58.575+07	2024-10-02 10:58:58.575+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d9e1a6f6-ffd0-4cf9-b8bd-be9b717d256a	HK.01	PERATURAN PERUNDANG-UNDANGAN EKSTERNAL (DI LUAR LPP RRI)	2024-10-02 10:59:33.461+07	2024-10-02 10:59:33.461+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
447c5501-f2a0-4546-969c-88b8fa298447	HK.01.01	Undang-Undang	2024-10-02 10:59:54.658+07	2024-10-02 10:59:54.658+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
898fbc2a-4d0a-4256-8933-8df0d0358dd5	HK.01.02	Peraturan Pemerintah	2024-10-02 11:00:13.35+07	2024-10-02 11:00:13.35+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
99b8a053-7e5c-45e7-b931-4a62ea2782de	HK.01.03	Peraturan Presiden	2024-10-02 11:00:28.809+07	2024-10-02 11:00:28.809+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
2d8fb10c-23f1-4bb2-b222-c3a50594994e	HK.01.04	Keputusan Presiden	2024-10-02 11:00:49.44+07	2024-10-02 11:00:49.44+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
5ab4a276-ec98-4241-bdd6-0079a4303da1	HK.01.05	Instruksi Presiden	2024-10-02 11:01:05.083+07	2024-10-02 11:01:05.083+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
6016e766-39d2-4370-adaf-62b3a4fc28df	HK.01.06	Surat Edaran	2024-10-02 11:01:21.156+07	2024-10-02 11:01:21.156+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
b0082ffc-f099-41b2-9d04-0e7602e71289	HK.01.07	Keputusan/Peraturan Lembaga/Badan	2024-10-02 11:01:45.012+07	2024-10-02 11:01:45.012+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d4ffeae1-4c95-4cc3-97e5-9e275dc1a8eb	HK.02	PERATURAN PERUNDANG-UNDANGAN INTERNAL (LPP RRI)	2024-10-02 11:02:17.614+07	2024-10-02 11:02:17.614+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
3e00902b-59f4-4c59-8441-257154f1055b	HK.02.01	Peraturan Dewan Pengawas	2024-10-02 11:02:36.537+07	2024-10-02 11:02:36.537+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
f0899f40-a084-4fbc-a95d-4e6f00d8dc1c	HK.02.02	Keputusan Dewan Pengawas	2024-10-02 11:02:59.536+07	2024-10-02 11:02:59.536+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
319a2293-155e-4014-9a1f-a65795ab7fbf	HK.02.03	Instruksi Dewan Pengawas	2024-10-02 11:03:38.812+07	2024-10-02 11:03:38.812+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
2c58db90-48e4-4066-a9ed-d7180b49449a	HK.02.04	Peraturan Dewan Direksi	2024-10-02 11:03:57.281+07	2024-10-02 11:03:57.281+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
c349a4a6-bebe-496e-90d6-06af7b356654	HK.02.05	Keputusan Dewan Direksi	2024-10-02 11:04:14.46+07	2024-10-02 11:04:14.46+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
f394e4a8-d726-4d99-acac-86aedd4641f8	HK.02.06	Instruksi Dewan Direksi	2024-10-02 11:04:30.511+07	2024-10-02 11:04:30.511+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
978a939e-bf6a-4d54-b7e4-5454a2fc3602	HK.02.07	Surat Edaran/Nota Dinas\n	2024-10-02 11:04:51.8+07	2024-10-02 11:04:51.8+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
1dadea36-0c99-4dd9-9fb4-667c329edbc0	HK.03	PERATURAN BERSAMA/SURAT EDARAN BERSAMA DAN KESEPAKATAN BERSAMA (MoU)	2024-10-02 11:05:33.148+07	2024-10-02 11:05:33.148+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
7f48a000-fb26-452e-9c2d-d79933d62eb1	HK.03.01	Luar Negeri	2024-10-02 11:05:45.801+07	2024-10-02 11:05:45.801+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
f93df5ae-bb37-4bc2-b1f7-9951d4dc5913	HK.03.02	Dalam Negeri	2024-10-02 11:06:03.608+07	2024-10-02 11:06:03.608+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
83a10a5c-e037-40b8-be7d-3ee4f5faebd4	HK.04	PERDATA	2024-10-02 11:10:49.919+07	2024-10-02 11:10:49.919+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
98057351-7510-4e99-a41b-a51dfe45d9b8	HK.04.01	Tentang Orang/Pengaduan/Somasi/Sengketa/Perlindungan Hukum	2024-10-02 11:11:36.375+07	2024-10-02 11:11:36.375+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
88db1242-3833-4efa-b882-6ed2ced0ff7f	HK.04.02	Tentang Kebendaan	2024-10-02 11:12:01.257+07	2024-10-02 11:12:01.257+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
c9bca244-cd14-43c1-9855-81c46c3dc236	HK.04.03	Tentang Perikatan	2024-10-02 11:12:32.353+07	2024-10-02 11:12:32.353+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
c6b8e722-f79d-44cb-b5cb-23325e4216c5	HK.04.04	Tentang Pembuktian dan Kadaluwarsa	2024-10-02 11:12:52.142+07	2024-10-02 11:12:52.142+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e3f150c0-be8b-4275-a96c-b2163c3886a4	HK.05	PIDANA	2024-10-02 11:13:04.577+07	2024-10-02 11:13:04.577+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
304dda9c-e6d1-4ce5-aaf8-d15345504c77	HK.05.01	Kejahatan	2024-10-02 11:13:17.638+07	2024-10-02 11:13:17.638+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
7e7036b5-076f-434d-beb3-4981148622d9	HK.05.02	Pelanggaran/Peringatan/Teguran/Pencabutan	2024-10-02 11:13:47.221+07	2024-10-02 11:13:47.221+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
2ff5df72-b4e2-4342-af00-3b95d7ebfc9f	HK.05.03	Korupsi Kolusi Nepotisme (KKN)	2024-10-02 11:14:28.317+07	2024-10-02 11:14:28.317+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
dd864b66-49c8-40e1-b75b-7189157c1271	HK.06	TATA USAHA/ADMINISTRASI NEGARA	2024-10-02 11:16:33.584+07	2024-10-02 11:16:33.584+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
2dec7b5b-f1ac-4824-9403-0f792b3fb7ff	HK.06.01	Gugatan	2024-10-02 11:16:54.353+07	2024-10-02 11:16:54.353+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
9307cc38-48e6-45ad-8e91-84269fa133b8	HK.06.02	Putusan	2024-10-02 11:17:05.14+07	2024-10-02 11:17:05.14+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
a1c0ccdb-d4ce-4b11-b326-1367bf931815	OT	ORGANISASI DAN TATA LAKSANA	2024-10-02 11:17:22.511+07	2024-10-02 11:17:22.511+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
9eb91706-d560-4146-a879-33bdeaac6f77	OT.01	ORGANISASI	2024-10-02 11:17:36.504+07	2024-10-02 11:17:36.504+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
8e174bbb-ea70-4d6b-8ce2-a7a0f4dcbd2b	OT.01.01	Organisasi (Rencana, Penetapan Struktur dan Evaluasi)	2024-10-02 11:18:03.262+07	2024-10-02 11:18:03.262+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
6dd2dfb1-6a48-414d-8329-c980102a454c	OT.01.02	Reformasi Birokrasi	2024-10-02 11:18:21.998+07	2024-10-02 11:18:21.998+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
eaa75867-880b-48cf-ad72-cff4beaa1725	OT.02	TATA LAKSANA	2024-10-02 11:18:44.4+07	2024-10-02 11:18:44.4+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
8e8b16bc-11d2-4baf-bf3a-092ffddc15b5	OT.02.01	Rencana, Penetapan, dan Evaluasi	2024-10-02 11:19:13.807+07	2024-10-02 11:19:13.807+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
031bb376-f461-4e1e-9a01-e51a33fd4e75	OT.02.02	Pembakuan Mekanisme Kerja/SOP	2024-10-02 11:19:32.562+07	2024-10-02 11:19:32.562+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
11392069-057c-46bd-8361-0f4e4cf23d24	OT.02.03	Logo	2024-10-02 11:19:54.113+07	2024-10-02 11:19:54.113+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
9cee504e-a7ac-407b-9ee6-319d8453dad9	KS	KERJASAMA	2024-10-02 11:21:21.671+07	2024-10-02 11:21:21.671+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
b508d829-a465-48b3-b008-af5c3dd3d296	KS.01	LINTAS SEKTORAL	2024-10-02 11:21:33.816+07	2024-10-02 11:21:33.816+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
836989ed-7099-49d3-8fb6-cf3d063c94f8	KS.01.01	Koordinasi Lintas Sektorat	2024-10-02 11:21:55.248+07	2024-10-02 11:21:55.248+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
fd84b63f-96a8-4749-9534-7c77b2a7b604	KS.01.02	Koordinasi Lintas Daerah	2024-10-02 11:22:10.971+07	2024-10-02 11:22:10.971+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
3b296a91-afed-47ec-a82b-f2385f144d43	KS.01.03	Koordinasi Internal dan Eksternal LPP RRI	2024-10-02 11:22:40.548+07	2024-10-02 11:22:52.716+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
35513692-6cbb-4bed-9932-9d15dbb6baf6	KS.02	MULTILATERAL	2024-10-02 11:23:07.806+07	2024-10-02 11:23:07.806+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
2b376207-1d41-4e71-af44-75a9109ab85d	KS.02.01	Sumber Daya dan Perangkat Teknologi Penyiaran Terestial Analog dan Digital	2024-10-02 11:23:41.34+07	2024-10-02 11:23:41.34+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e3dd2d58-3628-41a8-8ea6-a58c10aa61cf	KS.02.02	Alih Teknologi dan Pengembangan SDM	2024-10-02 11:24:08.852+07	2024-10-02 11:24:08.852+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
57af9ab9-ba8f-4be1-86dd-bf2b923304b7	KS.02.03	Penyelenggaraan Siaran Radio	2024-10-02 11:24:28.124+07	2024-10-02 11:24:28.124+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
f8e508b8-d9d2-4a6b-be76-15235925ebf2	KS.02.04	Aplikasi Teknologi Digital / Multiplatform	2024-10-02 11:24:47.935+07	2024-10-02 11:24:47.935+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
70ec088e-0e62-463e-b6c9-5fb79076905b	KS.03	REGIONAL	2024-10-02 11:25:00.708+07	2024-10-02 11:25:00.708+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
cf307ead-9f59-4e64-8ec2-897d902e6ad1	KS.03.01	Sumber Daya dan Perangkat Teknologi Penyiaran Terestrial Analog dan Digital	2024-10-02 11:25:44.311+07	2024-10-02 11:25:44.311+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d7c5d9fb-3ff4-4e8a-a917-a633f475d998	KS.03.02	Alih Teknologi dan Pengembangan SDM	2024-10-02 11:26:07.573+07	2024-10-02 11:26:07.573+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
996fd4bc-15c7-4927-a1c8-3b18f6a7abed	KS.03.03	Penyelenggaraan Siaran Radio	2024-10-02 11:26:32.383+07	2024-10-02 11:26:32.383+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
40fa62dd-bec2-4726-b85d-557904d61316	KS.03.04	Aplikasi Teknologi Digital / Multiplatform	2024-10-02 11:26:59.118+07	2024-10-02 11:26:59.118+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
5b4d2d61-fb9b-452c-aebc-5dc2fd3997ae	KS.04	BILATERAL	2024-10-02 11:27:24.984+07	2024-10-02 11:27:36.6+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
fd52954a-ef27-4378-94ff-8fb3556c572e	KS.04.01	Sumber Daya dan Perangkat Teknologi Penyiaran Terestrial Analog dan Digital	2024-10-02 11:27:48.39+07	2024-10-02 11:27:48.39+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
03e09300-7ce5-4f84-bddd-05351c76f536	KS.04.02	Alih Teknologi dan Pengembangan SDM	2024-10-02 11:28:12.698+07	2024-10-02 11:28:12.698+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
dbcb309b-7a57-47d0-8e6b-c40e871bf670	KS.04.03	Penyelenggaraan Siaran Radio	2024-10-02 11:28:35.083+07	2024-10-02 11:28:35.083+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
83fa09b6-3c45-4587-bb17-2634da7312f1	KS.04.04	Aplikasi Teknologi Digital / Multiplatform	2024-10-02 11:28:55.212+07	2024-10-02 11:28:55.212+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
79381c0b-7dad-4801-aee3-e0accdf88890	HM	INFORMASI DAN HUBUNGAN MASYARAKAT	2024-10-02 11:29:18.117+07	2024-10-02 11:29:18.117+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
edceca74-a55a-4e77-8aa0-0550d0b49611	HM.01	Hubungan Masyarakat	2024-10-02 11:29:33.93+07	2024-10-02 11:29:33.93+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
f5687943-7cb7-4cff-86d8-5fa1a2f2d72a	HM.01.01	Dokumentasi/liputan kegiatan dinas pimpinan, pengumpulan, pengolahan dan penyajian informasi kegiatan	2024-10-02 11:30:18.218+07	2024-10-02 11:30:18.218+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d127dbb8-e5cf-46eb-ac98-cacdb0e957c8	HM.01.02	Hubungan antar lembaga	2024-10-02 11:30:35.841+07	2024-10-02 11:30:35.841+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
262260cb-2348-4fe4-a886-c6119b3b9f2c	HM.01.03	Dengar Pendapat (RDP) Komisi I DPR RI	2024-10-02 11:31:14.911+07	2024-10-02 11:31:14.911+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
709a7ef4-eee8-4674-8c8f-b294e87de21f	HM.01.04	Sosialisasi, bahan/materi pidato/sidang MPR, DPR, DPD, kabinet, DPRD Provinsi/Kabupaten/Kota	2024-10-02 11:32:05.341+07	2024-10-02 11:32:05.341+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
39f410e2-d3cf-4fcf-8711-acc61c629db5	HM.01.05	Lomba, festival, penghargaan/tanda kenang-kenangan kepada masyarakat/publik	2024-10-02 11:32:40.446+07	2024-10-02 11:32:40.446+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
493e8b80-7781-4c47-9d9d-8a77084a1d2f	HM.01.06	Ucapan terima kasih, ucapan selamat, belasungkawa, dan permohonan maaf di lingkungan LPP RRI	2024-10-02 11:33:21.534+07	2024-10-02 11:33:21.534+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
898e86b1-342f-4a9e-b14c-2a7ba223588a	HM.02	INFORMASI	2024-10-02 11:33:33.895+07	2024-10-02 11:33:33.895+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
28454ae0-93de-416b-ad7a-c08b75390f9b	HM.02.01	Sosialisasi	2024-10-02 11:33:57.332+07	2024-10-02 11:33:57.332+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
59d7b77f-1cda-47b2-81bd-be803c8614f3	HM.02.02	Pers/Media Massa/Website	2024-10-02 11:34:19.996+07	2024-10-02 11:34:19.996+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
a0045276-4469-4d3f-83c9-cabb08e68047	HM.02.03	Pameran/Festival	2024-10-02 11:34:35.821+07	2024-10-02 11:34:35.821+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
b7bb62de-3409-4ea5-b33b-2e4bc364bc94	PB	PUBLIKASI	2024-10-02 11:34:45.979+07	2024-10-02 11:34:45.979+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
6a993acf-f5cc-43ae-8ac0-4ee5bd1de5df	PB.01	PENERBITAN	2024-10-02 11:35:04.79+07	2024-10-02 11:35:04.79+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d79f1d0f-8e09-4725-9222-bd1ee23a74e2	PB.02	DOKUMENTASI	2024-10-02 11:36:23.843+07	2024-10-02 11:36:23.843+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
1df42266-21e4-44e0-99f7-1092c0180368	PB.01.01	Kehumasan melalui penerbitan/website dalam lingkup Lembaga Penyiaran Publik Radio Republik Indonesia	2024-10-02 11:35:44.271+07	2024-10-02 11:37:42.581+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
1b2211d8-7752-4f54-9a01-26da5f84a3db	PB.02.01	Kehumasan, kepustakakan dan perpustakaan di lingkungan Lembaga Penyiaran Publik Radio Republik Indonesia	2024-10-02 11:36:44.276+07	2024-10-02 11:37:55.3+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
51f9978b-6211-471a-8799-1e6f17e7a9ee	DT	DATA DAN SARANA PENYIARAN	2024-10-02 11:38:14.023+07	2024-10-02 11:38:14.023+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
741f1fdf-c594-4f5e-b18e-720ef5572382	DT.01	INFRASTRUKTUR PENYIARAN	2024-10-02 11:38:30.927+07	2024-10-02 11:38:30.927+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
8392c2cd-429c-4c65-b4fa-a7a88fa124a4	DT.01.01	Topologi Jaringan Backup/Data Recovery Center	2024-10-02 11:39:01.129+07	2024-10-02 11:39:01.129+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
0f888fcc-69a6-4b17-b7f9-8b8afdc7fa61	DT.01.02	Piranti teknologi penyiaran	2024-10-02 11:39:18.464+07	2024-10-02 11:39:18.464+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
6f67538f-57bf-44a4-8bfe-1b51153567e1	DT.01.03	Pengamanan informasi di lingkungan Lembaga Penyiaran Publik Radio Republik Indonesia\n	2024-10-02 11:39:58.151+07	2024-10-02 11:39:58.151+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
3570ad5b-88cf-40fb-8ca3-4772394050b7	DT.02	SISTEM DATA	2024-10-02 11:40:08.695+07	2024-10-02 11:40:08.695+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
b1a0fe82-0230-4d67-b54f-fd834ddf2b40	DT.02.01	Pemeliharaan Portal	2024-10-02 11:40:24.215+07	2024-10-02 11:40:24.215+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
988d6725-7dbf-4a81-8b87-3162f99cb4c2	DT.02.02	Pemeliharaan konten	2024-10-02 11:40:40.014+07	2024-10-02 11:40:40.014+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
de98c565-d989-4c7a-ad44-c16277d7342b	DT.02.03	Pengumpulan data	2024-10-02 11:40:53.61+07	2024-10-02 11:40:53.61+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e8b47a84-3158-4fc0-81ec-6161df8ee084	DT.02.04	Pengolahan data di lingkungan Lembaga Penyiaran Publik Radio Republik Indonesia	2024-10-02 11:41:39.524+07	2024-10-02 11:41:39.524+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
386fa978-8d22-4487-af84-f8dcbfa39a09	DT.03	APLIKASI	2024-10-02 11:41:52.529+07	2024-10-02 11:41:52.529+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
a44b3d2b-9c08-4738-ab99-452a3f07ef9a	DT.03.01	Perancangan Aplikasi	2024-10-02 11:42:07.707+07	2024-10-02 11:42:07.707+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
f93485a0-c0db-4882-a2db-f0408539af80	DT.03.02	User Acceptance Test	2024-10-02 11:42:25.538+07	2024-10-02 11:42:25.538+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
781ad3a5-2d44-485d-a48d-c41c67017c85	DT.03.03	Pemeliharaan aplikasi	2024-10-02 11:42:48.553+07	2024-10-02 11:42:48.553+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
6731e232-3c7a-4f88-bc52-33bb9ba7388f	DT.03.04	Audit aplikasi di lingkungan Lembaga Penyiaran Publik Radio Republik Indonesia	2024-10-02 11:43:08.961+07	2024-10-02 11:43:08.961+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
4c317788-ce6c-49bf-a894-b8742d0601ea	LT	PENELITIAN DAN PENGEMBANGAN SDM	2024-10-02 11:43:24.707+07	2024-10-02 11:43:24.707+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
389b82de-fa78-4c15-a934-f7e60f3e05e9	LT.01	Penelitian Teknologi Sistem Penyiaran	2024-10-02 11:43:45.175+07	2024-10-02 11:43:45.175+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
47d4fdae-88a3-4afc-8602-b4fda15bbd10	LT.02	Pengembangan Teknologi Sistem Penyiaran	2024-10-02 11:44:11.055+07	2024-10-02 11:44:11.055+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
fac27ed6-9e38-4849-a9df-7f044b64203f	LT.03	Pembinaan dan Pengembangan SDM Penyiaran	2024-10-02 11:44:30.594+07	2024-10-02 11:44:30.594+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
80ae6982-189e-48cd-ac53-2bd721185513	STO	STUDIO DAN SARANA PRASARANA	2024-10-02 11:44:46.615+07	2024-10-02 11:44:46.615+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
2e2504b2-d813-4ce0-8f07-05192c5c9040	STO.01	KATALOG	2024-10-02 11:44:57.722+07	2024-10-02 11:44:57.722+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
2ce8170f-adfa-4685-a7e8-0238720c14ce	STO.01.01	Katalog Peralatan Studio	2024-10-02 11:45:21.808+07	2024-10-02 11:45:21.808+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
95e990e9-9087-4ff8-a186-1295a4524e0b	STO.01.02	Katalog Genset	2024-10-02 11:45:37.074+07	2024-10-02 11:45:37.074+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
3334a7fb-e679-4fb0-b5d9-74a4ef87ed91	STO.01.03	Katalog Tower	2024-10-02 11:45:49.621+07	2024-10-02 11:45:49.621+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
55e4cb67-fd4a-4fcb-9b4a-b456bd62509c	STO.02	SPESIFIKASI PERALATAN	2024-10-02 11:46:04.416+07	2024-10-02 11:46:04.416+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
4eb79076-f964-40c5-aa89-f280aa59ee00	STO.02.01	Spesifikasi Peralatan Studio	2024-10-02 11:46:22.127+07	2024-10-02 11:46:22.127+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
cb472e4e-5ecf-40e2-b8ec-42a4e4397c89	STO.02.02	Spesifikasi Genset\n	2024-10-02 11:46:39.282+07	2024-10-02 11:46:39.282+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
20ed9c9f-53e3-46ae-b7aa-1283fc571aea	STO.02.03	Spesifikasi Tower	2024-10-02 11:46:58.96+07	2024-10-02 11:46:58.96+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
2a88d3e0-10ea-405e-8dc0-e626bab0f14c	STO.02.04	Spesifikasi Grounding	2024-10-02 11:47:26.199+07	2024-10-02 11:47:26.199+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
4ed58ae8-3cf0-4014-9ba1-fb4f39fedabe	STO.03	SERTIFIKAT PERALATAN TEKNIK	2024-10-02 11:47:46.311+07	2024-10-02 11:47:46.311+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e7794f84-a6c8-488b-b28a-ca8f8fc2c3e9	STO.04	STANDAR PERALATAN TEKNIK	2024-10-02 11:48:15.712+07	2024-10-02 11:48:15.712+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
9addf916-0fa2-4db0-9227-6559668d8a72	STO.04.01	Standar Peralatan Teknik Multimedia	2024-10-02 11:48:47.364+07	2024-10-02 11:48:47.364+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
9e247dcb-13ca-4c6a-82fe-90418038eaa5	STO.04.02	Standar Peralatan Teknik Studio	2024-10-02 11:48:58.633+07	2024-10-02 11:48:58.633+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
bce91311-24d6-40e0-892f-95314d9243da	STO.04.03	Standar Peralatan Teknik Siaran Luar	2024-10-02 11:49:13.452+07	2024-10-02 11:49:13.452+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
be3e8034-51f1-4b69-b7a1-15aa1a994db5	STO.05	SOP PERALATAN TEKNIK	2024-10-02 11:49:33.219+07	2024-10-02 11:49:33.219+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
97da9d8a-b469-402f-b8cb-b276be222edc	STO.05.01	SOP Peralatan Teknik Studio	2024-10-02 11:49:54.285+07	2024-10-02 11:49:54.285+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
1e2eca17-fb69-4ce6-9e3f-96f9fe6778ea	STO.05.02	SOP Peralatan Teknik Siaran Luar\n	2024-10-02 11:50:06.918+07	2024-10-02 11:50:06.918+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
22b83913-aaee-4cd0-b725-413980504870	STO.05.03	SOP Peralatan Teknik Multimedia	2024-10-02 11:50:27.786+07	2024-10-02 11:50:27.786+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
ad488909-0299-43e2-8a3c-7696dc635c1b	STO.06	TANDA TERIMA BARANG\n	2024-10-02 11:50:51.133+07	2024-10-02 11:50:51.133+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
89b7c20d-f9ca-4e93-9c56-98d05ef2278d	TX	TRANSMISI DAN DISTRIBUSI	2024-10-02 11:51:07.52+07	2024-10-02 11:51:07.52+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
8b12bcb2-d526-4f35-be09-cbc67382b21e	TX.01	KATALOG	2024-10-02 11:51:19.534+07	2024-10-02 11:51:19.534+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
6e983498-4e42-49ae-8e5f-5ed96a5c325f	TX.01.01	Katalog Pemancar	2024-10-02 11:51:37.137+07	2024-10-02 11:51:37.137+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
a420bfdd-e24f-46d1-8959-8b78ad2d34c9	TX.01.02	Katalog Antena	2024-10-02 11:51:54.142+07	2024-10-02 11:51:54.142+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
f608e9af-c847-499f-8108-26637c413918	TX.01.03	Katalog STL	2024-10-02 11:52:08.75+07	2024-10-02 11:52:08.75+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
4b8dd983-0ddd-4272-926d-58097b1d5459	TX.02	SPESIFIKASI PEMANCAR	2024-10-02 11:52:26.624+07	2024-10-02 11:52:26.624+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
69e505ce-beaa-4322-b115-0bd1937fb905	TX.02.01	Spesifikasi Jenis Pemancar	2024-10-02 11:52:48.356+07	2024-10-02 11:52:48.356+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
cc0e3ff2-39c0-45b5-830a-ab1c4c795b50	TX.02.02	Spesifikasi Antena	2024-10-02 11:53:02.131+07	2024-10-02 11:53:02.131+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
626ca118-0845-45f2-ba16-83840e18e65f	TX.02.03	Spesifikasi STL	2024-10-02 11:53:15.47+07	2024-10-02 11:53:15.47+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
8749076a-e258-423c-b25e-1796d08863e9	TX.02.04	Spesifikasi Up-Link dan Down-Link	2024-10-02 11:53:34.895+07	2024-10-02 11:53:34.895+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d18198e5-146c-4ab2-860d-1a936a895169	TX.03	SERTIFIKAT PERALATAN PEMANCAR\n	2024-10-02 11:53:55.267+07	2024-10-02 11:53:55.267+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d7648f3b-92e3-4e15-a088-b13a8cdea5f1	TX.04	IZIN STASIUN RADIO (ISR)	2024-10-02 11:54:28.082+07	2024-10-02 11:54:28.082+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e52d5a75-6b06-46f0-a3c2-073d91bdd613	TX.05	PEMBAYARAN BHP	2024-10-02 11:54:42.707+07	2024-10-02 11:54:42.707+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e90d549a-d777-40b3-802f-8e717f356aee	TX.06	MASTERPLAN PEMANCAR	2024-10-02 11:55:06.307+07	2024-10-02 11:55:06.307+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
18846fb4-00ee-41c6-91c3-4a1f45aa6041	TX.06.01	AM Analog-Digital	2024-10-02 11:55:41.96+07	2024-10-02 11:55:41.96+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
742b97df-d9fc-4459-b30d-7cd29c0c7328	TX.06.02	FM Analog-Digital	2024-10-02 11:55:55.992+07	2024-10-02 11:55:55.992+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
67d0e9bc-488f-4622-b7d9-24fd31fa91eb	TX.06.03	SW Analog-Digital	2024-10-02 11:56:19.077+07	2024-10-02 11:56:19.077+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
ab46ebf4-2327-45e6-95a1-0cd44be9103c	TX.06.04	DAB+	2024-10-02 11:56:31.689+07	2024-10-02 11:56:31.689+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
c288e3a2-5475-4f8d-925a-a4e8812a164b	TX.06.05	DRM	2024-10-02 11:56:55.856+07	2024-10-02 11:56:55.856+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
112f6f04-b7de-4374-a69a-f7d2f831b4d8	TX.07	DATA COVERAGE AREA	2024-10-02 11:57:14.211+07	2024-10-02 11:57:14.211+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
4f9cb9d3-87f3-4c62-96f0-60244fdd0653	TX.07.01	Data Pengukuran Coverage	2024-10-02 11:57:38.994+07	2024-10-02 11:57:38.994+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
0a81dc25-0362-4b29-911f-9aef66e3b49a	TX.07.02	Data Survey Lokasi	2024-10-02 11:57:56.992+07	2024-10-02 11:57:56.992+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
f7ed00f9-9e54-4cba-adff-664001766028	TX.08	SOP PEMANCAR	2024-10-02 13:08:11.674+07	2024-10-02 13:08:11.674+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
8bfd8cc4-9387-4c58-9efb-2f74f66760e0	TX.08.01	SOP Pemancar Analog	2024-10-02 13:08:42.159+07	2024-10-02 13:08:42.159+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e22268f6-579b-46f8-8810-f6e32d0b32c3	TX.08.02	SOP Pemancar Digital	2024-10-02 13:08:58.132+07	2024-10-02 13:08:58.132+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e5a020f4-bdf4-4da9-9bf6-d252606b5053	TX.09	MEMORANDUM OF UNDERSTANDING (MOU)	2024-10-02 13:09:26.14+07	2024-10-02 13:09:26.14+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
07d9ff35-11ec-4199-ba20-cfed1c69bfc2	IT	INFORMASI TEKNOLOGI DAN MEDIA BARU	2024-10-02 13:09:48.869+07	2024-10-02 13:09:48.869+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
fbf9568e-aea7-4b4d-b35a-a0db118aecdd	IT.01	DOKUMEN PENGADAAN	2024-10-02 13:10:04.742+07	2024-10-02 13:10:04.742+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
3bee9e0d-1240-4af0-9482-04beee364251	IT.01.01	Barang/Peralatan Multimedia	2024-10-02 13:10:27.714+07	2024-10-02 13:10:27.714+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
01ea52d6-9291-4298-8b04-f4bc2e8621ed	IT.01.02	Jaringan/Bandwidth	2024-10-02 13:10:56.069+07	2024-10-02 13:10:56.069+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
91005ddf-f98b-45a9-8dd5-340391472c0a	IT.02	MEMORANDUM OF UNDERSTANDING (MOU)	2024-10-02 13:11:13.71+07	2024-10-02 13:11:13.71+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e4fa020b-6be2-4c93-8ec3-ec02081d5d2e	IT.03	DAFTAR BARANG INVENTARIS\n	2024-10-02 13:11:27.95+07	2024-10-02 13:11:27.95+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
4e6012a3-8d1f-4b31-a800-89fcdbc52e63	IT.03.01	Inventaris Peralatan Teknik	2024-10-02 13:11:50.678+07	2024-10-02 13:11:50.678+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
93e0e99f-092b-46ac-9144-54a10bd6367c	IT.03.02	Inventaris Pengadaan Barang	2024-10-02 13:12:08.483+07	2024-10-02 13:12:08.483+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
b2834cf0-fb1c-4a3d-94a7-5cdec73eeefe	IT.04	SUKU CADANG	2024-10-02 13:12:38.439+07	2024-10-02 13:12:38.439+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
89e872b1-c430-4a97-a789-8023cc573d30	IT.04.01	Daftar Sparepart Teknik	2024-10-02 13:13:27.376+07	2024-10-02 13:13:27.376+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
eda79cf1-c3c3-4fba-bc7a-f7ab96a7ae26	IT.04.02	Software-Softcopy	2024-10-02 13:13:46.944+07	2024-10-02 13:13:46.944+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
093f5e95-b822-444f-befa-c83082ea48a9	IT.05	MANUAL BOOK PERALATAN TEKNIK	2024-10-02 13:14:09.825+07	2024-10-02 13:14:09.825+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
bc5ab38b-930b-4d67-b399-a53a800e0314	IT.05.01	Handbook Manual	2024-10-02 13:14:28.481+07	2024-10-02 13:14:28.481+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
783779bc-70ef-4099-acf7-6a1f44d4c7ab	IT.05.02	Brosur IT	2024-10-02 13:14:39.866+07	2024-10-02 13:14:39.866+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
bec60845-0e5d-45d7-9c5f-34cc75ebd6b4	IT.06	SOP PERALATAN MULTIPLATFORM	2024-10-02 13:16:07.367+07	2024-10-02 13:16:07.367+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
07143144-d9a5-467b-b85b-01d9eeacef1d	IT.06.01	Audio	2024-10-02 13:16:19.034+07	2024-10-02 13:16:19.034+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
8b90555b-d148-4ad6-9f9e-f45321cfeed5	IT.06.02	Visual	2024-10-02 13:16:32.066+07	2024-10-02 13:16:32.066+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
ebc605b4-82f6-4618-9564-f151eb6304d9	PPS	PROGRAM DAN PRODUKSI SIARAN	2024-10-02 13:17:08.926+07	2024-10-02 13:17:08.926+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
a0c0bc9c-09e2-410d-862e-e985a2085a85	PPS.01	PENYUSUNAN KEBIJAKAN PROGRAM PRODUKSI SIARAN	2024-10-02 13:17:26.575+07	2024-10-02 13:17:26.575+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
c66a9897-8493-4f81-b418-bcbf79099793	PPS.01.01	SK Tim penyusun program dan kebijakan\n	2024-10-02 13:17:48.576+07	2024-10-02 13:17:48.576+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
ce361cb6-2065-4897-a67c-d8889f25a7ad	PPS.01.02	Surat masuk dan keluar	2024-10-02 13:18:02.112+07	2024-10-02 13:18:02.112+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
5bfb8f26-4285-4fc0-8e14-55d200b0d985	PPS.01.03	Dokumentasi (foto,video,audio)\n	2024-10-02 13:18:25.739+07	2024-10-02 13:18:25.739+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
89ad4594-bb53-4c98-8149-ddce0ea314ea	PPS.01.04	notulen	2024-10-02 13:18:38.755+07	2024-10-02 13:18:38.755+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
4ae415ed-0569-466a-9bc8-8bf64c1f7f70	PPS.01.05	materi penyusunan	2024-10-02 13:18:55.557+07	2024-10-02 13:18:55.557+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
506d7a33-4cdd-4ea9-831c-f4c6c35fa74e	PPS.01.06	Buku petunjuk SOP	2024-10-02 13:19:09.465+07	2024-10-02 13:19:09.465+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
06ab363c-bb5e-4849-8feb-8579089ae605	PPS.01.07	Juknis Pro 1, 2 dan 4\n	2024-10-02 13:19:35.111+07	2024-10-02 13:19:35.111+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
79bf8d42-b613-420f-b759-de3cb8ccc9f3	PPS.01.08	Juknis Siaran Lebaran	2024-10-02 13:19:49.032+07	2024-10-02 13:19:49.032+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
f7f7da42-5bdf-40cd-a359-57546ccf901e	PPS.01.09	laporan penyusunan	2024-10-02 13:20:04.443+07	2024-10-02 13:20:04.443+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
fc553ecb-b69c-4413-b92c-41658a24cc03	PPS.01.10	laporan keuangan	2024-10-02 13:20:18.027+07	2024-10-02 13:20:18.027+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
80027ca8-fc38-4713-8a6f-84d5681e33aa	PPS.02	ROYALTI DAN HAK CIPTA\n	2024-10-02 13:20:39.613+07	2024-10-02 13:20:39.613+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
ff25d206-df84-438e-9734-92b49900089c	PPS.02.01	laporan keuangan	2024-10-02 13:20:59.498+07	2024-10-02 13:20:59.498+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
ad8a2d97-90bf-4c84-a9f8-36ce474a7936	PPS.02.02	sertifikat	2024-10-02 13:21:32.47+07	2024-10-02 13:21:32.47+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
8934d251-30a0-4ada-91f0-1ccb02df4332	PPS.03	SWARA KENCANA AWARD	2024-10-02 13:21:52.033+07	2024-10-02 13:21:52.033+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
ae523131-209e-4824-b10c-9c89fcd7138b	PPS.03.01	SK Tim Swara Kencana	2024-10-02 13:22:09.213+07	2024-10-02 13:22:09.213+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
cf8cd679-9016-463f-8cc5-57747ff7f2e5	PPS.03.02	surat masuk dan keluar	2024-10-02 13:22:21.922+07	2024-10-02 13:22:21.922+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
ab873055-8b72-41b7-a44a-d45797c86084	PPS.03.03	dokumenasi (foto/video)	2024-10-02 13:22:38.097+07	2024-10-02 13:22:38.097+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
ed90bc40-7065-4f93-b798-bb871b8f32c4	PPS.03.04	notulen	2024-10-02 13:22:53.833+07	2024-10-02 13:23:02.921+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
f10cfc55-a197-4899-93ed-4f05ae7191e1	PPS.03.05	materi teks, audio, dan video peserta swaken	2024-10-02 13:23:31.804+07	2024-10-02 13:23:31.804+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
711ee9f0-9b23-491d-82dd-f06919f856cd	PPS.03.06	BA penjurian	2024-10-02 13:23:50.995+07	2024-10-02 13:23:50.995+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
6e50980c-0980-46e5-8b89-9492e062218d	PPS.03.07	SK pengumuman	2024-10-02 13:24:05.645+07	2024-10-02 13:24:05.645+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
892d286f-af1c-4ec9-a98b-e6b113f0fea4	PPS.03.08	laporan keuangan	2024-10-02 13:24:20.027+07	2024-10-02 13:24:20.027+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
1bc67c88-4cd6-4b36-a5a8-1580d116364a	PPS.04	BIMBINGAN TEKNIS PRODUKSI SIARAN	2024-10-02 13:24:50.36+07	2024-10-02 13:24:50.36+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
1aa1a55d-ed82-440c-98e3-a55f065e4d1f	PPS.04.01	surat masuk dan keluar	2024-10-02 13:25:03.276+07	2024-10-02 13:25:03.276+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
b3b07766-348e-4b04-a44f-048ff4de8c5b	PPS.04.02	SK tim	2024-10-02 13:25:13.662+07	2024-10-02 13:25:13.662+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
a5c950e2-1fd4-4617-92ca-7efcfe251b87	PPS.04.03	notulen	2024-10-02 13:25:31.666+07	2024-10-02 13:25:31.666+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
7540d969-48a5-4909-b947-1bbd65e7289e	PPS.04.04	dokuumentasi (foto, audio, video, materi bimtek, dan workshop)	2024-10-02 13:26:18.266+07	2024-10-02 13:26:18.266+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
65089f57-23aa-4df8-9e9f-5e4072970249	PPS.04.05	laporan	2024-10-02 13:26:44.147+07	2024-10-02 13:26:44.147+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
c9e67ed7-d584-4eb0-9e6f-43a8b6681c49	PPS.04.06	laporan keuangan	2024-10-02 13:26:56.081+07	2024-10-02 13:26:56.081+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
63480184-234c-494a-9d02-c853e6212f38	PPS.05	EVALUASI DAN MONITORING PRODUKSI SIARAN	2024-10-02 13:27:31.313+07	2024-10-02 13:27:31.313+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
c3dcb395-de34-4921-a682-000a5835b85c	PPS.05.01	SK Tim	2024-10-02 13:27:45.234+07	2024-10-02 13:27:45.234+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
4a0e6629-eec1-4797-82ef-e92b2a90861f	PPS.05.02 	surat masuk dan keluar	2024-10-02 13:28:24.007+07	2024-10-02 13:28:24.007+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
3a90da55-d859-44df-86ca-29f5b5302d3b	PPS.05.03	notulen	2024-10-02 13:28:40.518+07	2024-10-02 13:28:40.518+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
b9e4cc81-e667-490f-926c-10e8bd244096	PPS.05.04	dokumentasi (foto, audio, video)	2024-10-02 13:29:07.976+07	2024-10-02 13:29:07.976+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
3b4dc1a9-8587-45df-aaa2-9faf99bbb983	PPS.05.05	kontrak artis (SPK artis)	2024-10-02 13:29:27.424+07	2024-10-02 13:29:27.424+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
7623d22c-7ca2-4282-b72e-b66f7034d440	PPS.05.06	laporan keuangan	2024-10-02 13:29:40.058+07	2024-10-02 13:29:40.058+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
08d1a99a-5971-43c3-a364-1a9046210032	PPP	PROGRAM DAN PRODUKSI PEMBERITAAN	2024-10-02 13:30:00.654+07	2024-10-02 13:30:00.654+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
cdbfa87f-a5b4-437f-8aae-4b1d458a25e3	PPP.01	PENYUSUNAN KEBIJJAKAN PROGRAM PRODUKSI PEMBERITAAN	2024-10-02 13:30:26.769+07	2024-10-02 13:30:26.769+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
636274ca-11ec-4f7c-b0cc-f9228d76754b	PPP.01.01	SK tim penyusun program dan kebijakan	2024-10-02 13:30:50.573+07	2024-10-02 13:30:50.573+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e453b615-afa2-4d81-a0db-89ca4e22cc33	PPP.01.02	surat masuk dan keluar	2024-10-02 13:31:02.642+07	2024-10-02 13:31:02.642+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
72fb4b71-efed-46f0-b657-b7c3f43cf6eb	PPP.01.03	dokumentasi (foto, audio, video)	2024-10-02 13:31:23.248+07	2024-10-02 13:31:23.248+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
fac4f216-c92a-4881-b986-da8878acdd0a	PPP.01.04	notulen	2024-10-02 13:31:35.28+07	2024-10-02 13:31:35.28+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
7a1f6165-5973-4fb7-b50e-0b1c205d04b3	PPP.01.05	materi penyusunan	2024-10-02 13:31:47.656+07	2024-10-02 13:31:47.656+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
cc4f674b-d057-41be-8242-9ecb8b9e9aea	PPP.01.06	buku petunjuk SOP	2024-10-02 13:32:07.088+07	2024-10-02 13:32:07.088+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d5d568b3-371f-453f-aca7-0659a41e390b	PPP.01.07	juknis Pro 3	2024-10-02 13:32:41.457+07	2024-10-02 13:32:41.457+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
dc35f324-443b-45ec-a7f8-33b0bfde4ae4	PPP.01.08	juknis media online	2024-10-02 13:33:16.003+07	2024-10-02 13:33:16.003+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
142e831b-caa9-4e62-ab12-d1c5447e3a8c	PPP.01.09	juknis liputan haji	2024-10-02 13:33:38.384+07	2024-10-02 13:33:38.384+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
1865d2be-d46d-4579-9f54-b7da0d6f1845	PPP.01.10	juknis liputan pemilu	2024-10-02 13:33:53.304+07	2024-10-02 13:33:53.304+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
7bb613bf-6d42-494b-b485-76595b7ff471	PPP.01.11	laporan penyusunan kebijakan	2024-10-02 13:34:07.069+07	2024-10-02 13:34:07.069+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
f816365c-49b0-4479-a152-f3e197fc2dd4	PPP.01.12	laporan keuangan	2024-10-02 13:34:19.163+07	2024-10-02 13:34:19.163+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
df63193e-5063-443f-aa78-099e4efd9315	PPP.02	PEMBERIAN BIMBINGAN TEKNIS PRODUKSI PEMBERITAAN	2024-10-02 13:34:46.439+07	2024-10-02 13:34:46.439+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
566ff00e-6d09-4127-8fe3-2fd0b7466f79	PPP.02.01	surat masuk dan keluar	2024-10-02 13:35:08.876+07	2024-10-02 13:35:08.876+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e646a13b-afec-4b3f-acd1-c0d3954eadbb	PPP.02.02	SK tim	2024-10-02 13:35:23.295+07	2024-10-02 13:35:23.295+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
76986929-781b-4d78-921c-9b994ca7360f	PPP.02.03	notulen\n	2024-10-02 13:35:33.911+07	2024-10-02 13:35:33.911+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
36ac0947-534b-4062-b8fa-ebc0a9ba06e1	PPP.02.04	dokumentasi (foto, audio, video, materi bimtek dan workshop)	2024-10-02 13:36:00.617+07	2024-10-02 13:36:00.617+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
49dc95c4-36ca-4e49-b42f-241e5b7775f4	PPP.02.05	laporan bimtek\n	2024-10-02 13:36:13.021+07	2024-10-02 13:36:13.021+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
ac5e4281-c95f-42be-9ed5-b767dc5932b2	PPP.02.06	laporan keuangan	2024-10-02 13:36:41.133+07	2024-10-02 13:36:41.133+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
90ecaf0e-9873-4271-b37b-43cc98fcaa66	PPP.03	EVALUASI DAN MONITORING PRODUKSI PEMBERITAAN	2024-10-02 13:37:00.71+07	2024-10-02 13:37:00.71+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
58f0f5c6-9665-43bd-8a51-44eb393f4063	PPP.03.01	SK tim	2024-10-02 13:37:14.761+07	2024-10-02 13:37:14.761+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
9088b846-6ca5-4667-b8d0-be4ff4076991	PPP.03.02	Surat masuk dan keluar	2024-10-02 13:37:25.989+07	2024-10-02 13:37:25.989+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e5e300f4-b223-41ee-8196-8cfc989e1212	PPP.03.03	Notulen	2024-10-02 13:37:36.696+07	2024-10-02 13:37:36.696+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e4107811-4bad-4b05-b393-ef8205f8e52e	PPP.03.04	Dokumentasi (foto, audio, video)	2024-10-02 13:37:52.501+07	2024-10-02 13:37:52.501+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
ba96895d-7e29-4100-986a-a27bc08a2dfb	PPP.03.05	Laporan keuangan	2024-10-02 13:38:10.787+07	2024-10-02 13:38:10.787+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
446e6cb1-28e2-43d3-ae66-c1da1793a56d	PPP.03.06	Laporan evaluasi dan monitoring pemberitaan	2024-10-02 13:38:28.505+07	2024-10-02 13:38:28.505+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
db2c59a2-b97d-4985-b3a8-34b131a2861d	PPP.04	TALKSHOW KALENDER EVENT	2024-10-02 13:39:19.325+07	2024-10-02 13:39:19.325+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
c70836ce-9f87-4a74-b63b-5c9fa977ab31	PPP.04.01	SK tim talkshow	2024-10-02 13:39:47.713+07	2024-10-02 13:39:47.713+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
376eea9b-58ad-42ed-8671-1672266d952f	PPP.04.02	Surat masuk dan keluar	2024-10-02 13:40:01.39+07	2024-10-02 13:40:01.39+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
b4a8322f-9ce6-4a7a-993f-aae92b6ffb13	PPP.04.03	Dokumentasi (foto,video)	2024-10-02 13:40:21.41+07	2024-10-02 13:40:21.41+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e422841f-f00d-41c0-a2fe-339d29dae7e5	PPP.04.04	Notulen rapat	2024-10-02 13:40:32.929+07	2024-10-02 13:40:32.929+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
fe349609-3fb7-4718-9cda-9f496b924c1d	KJM	KERJASAMA & MULTIMEDIA	2024-10-02 13:41:11.899+07	2024-10-02 13:41:11.899+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
674b2f9b-b2b4-40a1-b9e5-062cc48627ed	KJM.01	PENYUSUNAN KEBIJAKAN KERJASAMA & MULTIMEDIA	2024-10-02 13:41:31.553+07	2024-10-02 13:41:31.553+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
f2d35ba2-d773-4d79-96f0-0a0d8394e2ee	KJM.01.01	SK tim penyusun kebijakan kerjasama dan multimedia\n	2024-10-02 13:42:06.409+07	2024-10-02 13:42:06.409+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e640c251-3153-4df0-8efb-0eb21615d8bb	KJM.01.02	Surat masuk dan keluar	2024-10-02 13:42:21.38+07	2024-10-02 13:42:21.38+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
b9bf6513-9d94-4cff-9e81-f85c27dfe56d	KJM.01.03	Dokumentasi (foto, video)	2024-10-02 13:42:38.014+07	2024-10-02 13:42:38.014+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
4aea8181-81f2-4d45-81ef-7b951380e2aa	KJM.01.04	Notulen	2024-10-02 13:42:51.665+07	2024-10-02 13:42:51.665+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
a5f6ee76-4c7f-4e26-a358-324f04f2aae4	KJM.01.05	Materi penyusunan	2024-10-02 13:43:10.309+07	2024-10-02 13:43:10.309+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
bb5ac2d6-f0d2-4f95-a400-fe96c75b93c6	KJM.01.06	Buku petunjuk SOP	2024-10-02 13:43:24.293+07	2024-10-02 13:43:24.293+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
a9026f95-244e-4600-8ed5-9c23fa36f8c5	KJM.01.07	Juknis kerjasam dan multimedia	2024-10-02 13:43:39.732+07	2024-10-02 13:43:39.732+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
ef5273e0-ad3a-45fd-a6a0-13a7d4e35066	KJM.01.08	Laporan penyusunan	2024-10-02 13:43:52.33+07	2024-10-02 13:43:52.33+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
3e4a70a6-e9a0-4c22-9316-07e9f0ed4383	KJM.01.09	Laporan keuangan	2024-10-02 13:44:08.998+07	2024-10-02 13:44:08.998+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
2b0289a9-122e-4bbe-97ff-eb03ff57f159	KJM.02	MOU Program siaran	2024-10-02 13:44:24.193+07	2024-10-02 13:44:24.193+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
ebe16bec-071a-4b7b-818a-4325d8a0e91e	KJM.02.01	Surat-surat	2024-10-02 13:44:35.714+07	2024-10-02 13:44:35.714+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
5e8b18a5-27af-4107-98d0-20628d6b0b22	KJM.02.02	Notulen rapat pembahasan	2024-10-02 13:44:54.319+07	2024-10-02 13:44:54.319+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
22e79402-18eb-4d05-8b15-b067472c8c15	KJM.02.03	Daftar hadir rapat	2024-10-02 13:45:07.672+07	2024-10-02 13:45:07.672+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
bdf05284-95b5-4815-8cb4-f1f90d08525c	KJM.02.04	Naskah MOU	2024-10-02 13:45:21.021+07	2024-10-02 13:45:21.021+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
862778f2-8108-47c6-a190-380e0fc599b4	KJM.02.05	Daftar hadir penandatanganan MOU	2024-10-02 13:46:16.807+07	2024-10-02 13:46:16.807+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
0888e40d-1601-459b-83ef-df4845adaf02	KJM.02.06	Dokumentasi kegiatan (foto, video, audio)	2024-10-02 13:46:36.42+07	2024-10-02 13:46:36.42+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
821e5a03-1dc2-49e2-a4cb-2adb30ca21a9	KJM.02.07	Laporan kegiatan	2024-10-02 13:46:48.538+07	2024-10-02 13:46:48.538+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
5dc56cb0-7eb8-4a22-966d-3d8b86bc7ee7	KJM.02.08	Evaluasi MOU	2024-10-02 13:47:00.84+07	2024-10-02 13:47:00.84+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
526cee60-6467-4eef-81de-223e20ea453c	KJM.02.09	Laporan keuangan	2024-10-02 13:47:13.769+07	2024-10-02 13:47:13.769+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
df65d31e-ec36-423f-a902-f7712978b5e2	KJM.03	Kemitraan RRI dengan Lembaga di tingkat Nasional	2024-10-02 13:47:49.1+07	2024-10-02 13:47:49.1+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
93b43749-d023-431e-a741-5eaa0e5a2968	KJM.03.01	SK kegiatan	2024-10-02 13:48:04.552+07	2024-10-02 13:48:04.552+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d954f15d-a353-4435-8058-96a66da2ced6	KJM.03.02	Nodin undangan peserta	2024-10-02 13:48:17.497+07	2024-10-02 13:48:17.497+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
2676012b-fa5a-4f21-a75c-993f6e08b59a	KJM.03.03	Daftar hadir	2024-10-02 13:48:31.597+07	2024-10-02 13:48:31.597+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d081184e-46b5-42f2-97f9-1d1049d87345	KJM.03.04	Surat-surat\n	2024-10-02 13:48:42.939+07	2024-10-02 13:48:42.939+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
fd9f4691-334c-4bfc-b4d7-5421b6efbc1f	KJM.03.05	Notulen	2024-10-02 13:48:53.66+07	2024-10-02 13:48:53.66+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
60ca8623-b947-46c1-a99c-6b7bedee9621	KJM.03.06	Materi narasumber	2024-10-02 13:49:12.944+07	2024-10-02 13:49:12.944+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
0842478e-c15b-4bd5-8997-3c8f0fe7bfc0	KJM.03.07	Dokumentasi kegiatan (foto, audio, video)	2024-10-02 13:49:36.18+07	2024-10-02 13:49:36.18+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
b32dbd2b-ebb9-406d-8203-7bdbfde31e96	KJM.03.08	Laporan keuangan	2024-10-02 13:50:05.259+07	2024-10-02 13:50:05.259+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
db033e40-2818-4ff9-aca9-fadaed9eb801	KJM.04	Kemitraan RRI dengan Lembaga di tingkat Internasional	2024-10-02 13:50:38.444+07	2024-10-02 13:50:38.444+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
8bc05eee-b4a0-419e-b65c-6686844d3169	KJM.04.01	SK kegiatan	2024-10-02 13:50:55.882+07	2024-10-02 13:50:55.882+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
8b884d28-eb65-47c1-a99b-ffe4a4d1efbf	KJM.04.02	Nodin undangan peserta	2024-10-02 13:51:09.135+07	2024-10-02 13:51:09.135+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
5edf5c8a-68ce-4e01-be87-617ce7be1aed	KJM.04.03	Daftar hadir	2024-10-02 13:51:22.023+07	2024-10-02 13:51:22.023+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e45dc988-9f87-424c-99a1-feada7dfca23	KJM.04.04	Surat-surat	2024-10-02 13:51:34.353+07	2024-10-02 13:51:34.353+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
74531666-a4f3-45de-a48a-2a50db260232	KJM.04.05	Notulen	2024-10-02 13:51:46.853+07	2024-10-02 13:51:46.853+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
103ab8f1-ec15-4f3f-a50c-c7061fbcf9d9	KJM.04.06	Materi narasumber	2024-10-02 13:51:58.998+07	2024-10-02 13:51:58.998+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
2eef3223-30c9-454a-8efc-66eff70883c4	KJM.04.07	Dokumentasi kegiatan (foto, video, audio)	2024-10-02 13:52:24.362+07	2024-10-02 13:52:24.362+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
aeddca2d-82ba-43fa-ad94-ff8a9a2dea95	KJM.04.08	Laporan kegiatan	2024-10-02 13:52:36.368+07	2024-10-02 13:52:36.368+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
ea00fc2b-80f5-47a7-86aa-12644f5f68b4	KJM.04.09	Evaluasi kegiatan	2024-10-02 13:52:48.998+07	2024-10-02 13:52:48.998+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
9817349e-b35d-412d-bd04-656d8fcb1db1	KJM.04.10	Laporan keuangan	2024-10-02 13:53:01.738+07	2024-10-02 13:53:01.738+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
cd7e6cf8-9f7f-4dab-a183-ce91836b10cf	KJM.05	Seleksi dan pendampingan kompetensi tingkat nasional dan internasional	2024-10-02 13:53:27.06+07	2024-10-02 13:53:27.06+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
243855b1-2ecf-49c4-8241-0c224f781025	KJM.05.01	Surat undangan	2024-10-02 13:53:56.586+07	2024-10-02 13:53:56.586+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
c22d3b1e-35fe-43cd-9cab-a44bb9bada98	KJM.05.02	Noutesi rapat	2024-10-02 13:54:21.507+07	2024-10-02 13:54:21.507+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
89458822-e187-45e6-8cd5-53151e96e833	KJM.05.03	Daftar hadir	2024-10-02 13:54:33.411+07	2024-10-02 13:54:33.411+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
523db39a-258c-4ecc-99db-36e726b99cdc	KJM.05.04	Penilaian terhadap paket siaran	2024-10-02 13:55:01.857+07	2024-10-02 13:55:01.857+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
6b416689-f535-4cba-8354-536b1d73da0f	KJM.05.05	Berita acara tim juri	2024-10-02 13:55:28.093+07	2024-10-02 13:55:28.093+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
0aeafecb-388e-4cbb-b403-10d321faa3d5	KJM.05.06	Pengumuman seleksi	2024-10-02 13:55:47.028+07	2024-10-02 13:55:47.028+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
5e7b1793-d079-4023-a408-f41a0b16cf13	KJM.05.07	Bukti pengiriman ke luar negeri	2024-10-02 13:56:02.199+07	2024-10-02 13:56:02.199+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
18a0f4cb-3858-4d78-84a6-cd447261f6e7	KJM.05.08	Dokumentasi kegiatan (foto, audio, video)	2024-10-02 13:56:20.737+07	2024-10-02 13:56:20.737+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
2adb2838-923c-4428-876a-26704281cdbd	KJM.05.09	Laporan kegiatan	2024-10-02 13:56:31.131+07	2024-10-02 13:56:31.131+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
d3407767-211d-4f92-b866-584c983d2041	KJM.05.10	Laporan kegiatan	2024-10-02 13:56:41.622+07	2024-10-02 13:56:41.622+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
c33a4f41-c905-4d19-85d0-31ad306f2dcc	KJM.05.11	Evaluasi kegiatan	2024-10-02 13:56:54.424+07	2024-10-02 13:56:54.424+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
43bdb775-1b0e-4740-9884-ebcbefa9fc53	KJM.06	Seleksi dan pembekalan koresponden RRI	2024-10-02 13:57:29.938+07	2024-10-02 13:57:29.938+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
a329a226-de78-4b3e-a72d-555560e206bb	KJM.06.01	Surat-surat terkait koresponden RRI	2024-10-02 13:57:55.727+07	2024-10-02 13:57:55.727+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
ee0a2f38-a5ec-4698-a36c-3e23e291990e	KJM.06.02	Noutesi rapat	2024-10-02 13:58:08.899+07	2024-10-02 13:58:08.899+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
3400114a-2891-4930-91fa-f717d85bd516	KJM.06.03	Daftar hadir\n	2024-10-02 13:58:26.102+07	2024-10-02 13:58:26.102+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
7e76a555-7219-4fc6-8c29-3e095d64b625	KJM.06.04	Lamaran (biodata, audio liputan) calon koresponden	2024-10-02 13:58:57.322+07	2024-10-02 13:58:57.322+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
8a598b3e-6b8f-4e4e-9851-2aaa272e5f99	KJM.06.05	Penilaian koresponden RRI	2024-10-02 13:59:13.13+07	2024-10-02 13:59:23.605+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
23a2b08d-14ed-4d4e-8750-80e4436f8cd5	KJM.06.06	Berita acara penilaian koresponden	2024-10-02 13:59:48.998+07	2024-10-02 13:59:48.998+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
b77c783f-efee-4dda-ab78-d5daaf85f3db	KJM.06.07	Pengumuman seleksi	2024-10-02 14:00:36.318+07	2024-10-02 14:00:36.318+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
723dee6d-fad7-44d9-9c67-35b515c082ab	KJM.06.08	Audio koresponden untuk seleksi penilaian	2024-10-02 14:01:02.225+07	2024-10-02 14:01:02.225+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
24e8fd94-98af-4f1d-9c40-c69f1b7adda2	KJM.06.09	Dokumentasi kegiatan (foto, audio, video)	2024-10-02 14:01:20.342+07	2024-10-02 14:01:20.342+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
b0ed8b53-53a8-483c-a401-d2d44d5837a1	KJM.06.10	Laporan kegiatan	2024-10-02 14:01:32.662+07	2024-10-02 14:01:32.662+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
331ac350-8ba9-4c92-80dd-7190322641a1	KJM.06.11	Evaluasi kegiatan	2024-10-02 14:01:44.441+07	2024-10-02 14:01:44.441+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
1bb1ffdb-4be3-44a8-b9f7-a96a5295324a	KJM.06.12	Laporan keuangan	2024-10-02 14:01:58.252+07	2024-10-02 14:01:58.252+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
82b3600f-62bd-4a24-bcce-7dc03b563746	KJM.07	Bimbingan teknis kerjasama dan multimedia	2024-10-02 14:02:23.636+07	2024-10-02 14:02:23.636+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
0c020b38-b565-4d49-8c27-2404b7aeff4b	KJM.07.01	Surat masuk dan keluar	2024-10-02 14:02:42.471+07	2024-10-02 14:02:42.471+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
45be5823-af9b-4bd1-a7a9-6a388c97b54a	KJM.07.02	SK tim	2024-10-02 14:02:53.362+07	2024-10-02 14:02:53.362+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e3b26bbd-20aa-420a-b4fa-18f4e59e7511	KJM.07.03	Notulen	2024-10-02 14:03:03.098+07	2024-10-02 14:03:03.098+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
2ff60bfe-68c7-450b-b2c7-4de770290d68	KJM.07.04	Dokumentasi (foto, audio, video, materi bimtek, dan workshop)	2024-10-02 14:03:36.85+07	2024-10-02 14:03:36.85+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
1c3678e9-9f6b-4cb6-b22b-18cdb60e8635	KJM.07.05	Laporan	2024-10-02 14:03:46.801+07	2024-10-02 14:03:46.801+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
36f3dd0f-bad6-42a0-9ab7-b63e344cd2b4	KJM.07.06	Laporan keuangan	2024-10-02 14:03:58.4+07	2024-10-02 14:03:58.4+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
343c5e13-654a-44a4-96c8-6406b6efed73	KJM.08	ALIH MEDIA AUDIO/VIDEO BERITA	2024-10-02 14:04:24.73+07	2024-10-02 14:04:24.73+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
12eedca5-6e54-4257-aa75-16435025f988	KJM.09	ALIH MEDIA AUDIO/VIDEO NON BERITA	2024-10-02 14:07:02.432+07	2024-10-02 14:07:02.432+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
376bb9ca-a778-4843-b035-5d69faa96c33	KJM.09.01	Pengumpulan data audio/video non berita	2024-10-02 14:07:23.34+07	2024-10-02 14:07:23.34+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
99f2ed94-6750-4bf8-831f-1f861b4edce8	KJM.09.02	Lagu	2024-10-02 14:07:35.72+07	2024-10-02 14:07:35.72+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
93bd98d7-2ce0-418f-a211-478eecfe2cfe	KJM.09.03	Jinggle	2024-10-02 14:07:45.736+07	2024-10-02 14:07:45.736+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
ad56fa0f-8a5b-4f2b-9519-d47cb6ab320f	KJM.09.04	Filler	2024-10-02 14:07:55.611+07	2024-10-02 14:07:55.611+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
e9fe301f-c946-49d6-befe-37a19c71ae80	KJM.09.05	Sandiwara radio	2024-10-02 14:08:08.29+07	2024-10-02 14:08:08.29+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
b0d890df-d65c-481c-9ec6-a828d48623be	KJM.09.06	Feature	2024-10-02 14:08:25.196+07	2024-10-02 14:08:25.196+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
6df4b3c4-11fe-4ab2-af90-dfcfcd01530b	KJM.09.07	Spot	2024-10-02 14:08:41.588+07	2024-10-02 14:08:41.588+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
a59063d5-b995-4588-b014-29bff7913d6c	KJM.09.08	Greetings	2024-10-02 14:08:53.584+07	2024-10-02 14:08:53.584+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
966c6496-9673-44b7-8831-d6f2c7b41198	KJM.09.09	Laporan keuangan	2024-10-02 14:09:11.629+07	2024-10-02 14:09:11.629+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
b9c29e15-182c-4b6c-8a99-c55863d18cb4	KP.01.05	Daftar Nominatif/Data Pegawai Honorer (kontrak)	2024-10-02 10:03:44.966+07	2024-10-03 07:07:53.23+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
cea029d8-4d17-4038-a11a-32613837c285	PPP.04.05	Laporan keuangan	2024-10-02 13:40:45.592+07	2024-10-03 07:13:05.15+07	4ca0a951-86e2-40df-90c4-40d900f85da9
04d8bcf4-457c-40f9-9c45-ab239435c87f	KJM.08.09	Teks berita	2024-10-02 14:06:27.625+07	2024-10-09 09:26:50.122+07	815a6644-46ee-4267-bd3d-b06067e80b2e
1987c793-d721-463d-96f3-c661f43be1ba	KJM.08.10	Laporan keuangan Pelaksanaan Kegiatan (acara terkait)	2024-10-02 14:06:39.901+07	2024-10-09 09:29:05.623+07	815a6644-46ee-4267-bd3d-b06067e80b2e
f9959c9f-5ba7-4a97-85c5-86d5bca081a7	KJM.08.08	News feature	2024-10-02 14:06:16.187+07	2024-10-09 09:30:21.987+07	815a6644-46ee-4267-bd3d-b06067e80b2e
ec7a34d4-526f-4072-a33a-6a6303e30351	KJM.08.07	News documenter	2024-10-02 14:06:04.78+07	2024-10-09 09:30:57.792+07	815a6644-46ee-4267-bd3d-b06067e80b2e
dd7d982f-e854-4ec4-9f20-71fc253fc39b	KJM.08.06	Indepth reporting\n	2024-10-02 14:05:50.719+07	2024-10-09 09:31:27.013+07	815a6644-46ee-4267-bd3d-b06067e80b2e
fd7cbbef-cb9c-4b2b-b844-21bf3e29afb8	KJM.08.05	Editorial	2024-10-02 14:05:31.017+07	2024-10-09 09:31:56.682+07	815a6644-46ee-4267-bd3d-b06067e80b2e
d57dbedd-5597-4a33-922e-d3110ab4daca	KJM.08.04	Talk show	2024-10-02 14:05:20.472+07	2024-10-09 09:32:40.809+07	815a6644-46ee-4267-bd3d-b06067e80b2e
da54a0a8-d3f6-4799-af86-07d2871f2090	KJM.08.03	Report On The Spot	2024-10-02 14:05:09.526+07	2024-10-09 09:33:45+07	815a6644-46ee-4267-bd3d-b06067e80b2e
8deefbcd-cbb4-4853-bf2a-0ef70b6afd73	KJM.08.02	News	2024-10-02 14:04:54.893+07	2024-10-09 09:34:29.877+07	815a6644-46ee-4267-bd3d-b06067e80b2e
b664e1e2-2694-47b3-ae73-c6fcb1fb21e4	KJM.08.01	Pengumpulan data audio/video berita	2024-10-02 14:04:46.815+07	2024-10-09 09:35:02.952+07	815a6644-46ee-4267-bd3d-b06067e80b2e
79c6dee3-1308-4f3a-afa9-dcfc397c525b	PR.02.03	Program dan Kegiatan berkala (Triwulan, Semester, dan Tahunan) serta Insidental	2024-10-02 09:38:41.041+07	2024-10-09 09:40:04.337+07	c7e59b55-f135-4de4-ad4f-ea8d26e76574
\.


--
-- Data for Name: archive_files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.archive_files (id, page, extension, created_at, updated_at, archive_id) FROM stdin;
43d7d0ea-24f9-4971-922b-371db0a26aa6	1	pdf	2024-10-07 07:45:49.228+07	2024-10-07 07:45:49.228+07	50bd91e3-b51b-49fe-b314-ca761e5a8504
cf45a486-890a-4c3c-8ada-d9b74a5115e8	1	pdf	2024-10-07 10:03:19.035+07	2024-10-07 10:03:19.035+07	decc9b58-021e-47b0-9ad3-42d4fd48997d
4c448b57-6af1-43cb-b45f-abd95ee6d45a	1	pdf	2024-10-08 13:33:05.09+07	2024-10-08 13:33:05.09+07	884c66f2-ad2b-4973-a87b-afe7b7a241a5
e24f8311-36e8-4e0e-ba44-355c0f9e0e23	1	pdf	2024-10-08 13:35:09.836+07	2024-10-08 13:35:09.836+07	23d266d6-ffe5-4147-a005-c570a69ec76b
704defd4-1f53-4f6f-b21b-20bca6daa404	1	pdf	2024-10-17 11:53:13.413+07	2024-10-17 11:53:13.413+07	a67ffe8a-4b54-4846-9ae4-455b66b2c53e
\.


--
-- Data for Name: archives; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.archives (id, title, published_at, retention_category, removed_at, description, created_at, updated_at, created_by, archive_code_id) FROM stdin;
50bd91e3-b51b-49fe-b314-ca761e5a8504	coba1	2024-10-07 07:45:00+07	temporary	2026-10-07 07:45:48+07		2024-10-07 07:45:48.387+07	2024-10-07 07:45:48.387+07	ca18e670-0eff-4997-8cf0-507297a137b4	3c016d1f-00e1-4852-8258-1a6a21aaff46
decc9b58-021e-47b0-9ad3-42d4fd48997d	abssen januari	\N	temporary	2026-10-07 10:03:19+07		2024-10-07 10:03:19.017+07	2024-10-07 10:03:19.017+07	58ed787d-f07c-4975-b844-8230e164be9e	df1ad1ff-77bf-46f8-ab0b-ce1abbb22bf4
884c66f2-ad2b-4973-a87b-afe7b7a241a5	Laporan Keu Triwulan 1	2024-10-08 13:31:00+07	useful	2034-10-08 13:33:04+07		2024-10-08 13:33:04.99+07	2024-10-08 13:33:04.99+07	36b9e357-6fc2-4478-abbf-7ec493837a1a	3c016d1f-00e1-4852-8258-1a6a21aaff46
23d266d6-ffe5-4147-a005-c570a69ec76b	Laporan Keu Triwulan 2	2024-10-08 13:34:00+07	temporary	2026-10-08 13:35:09+07		2024-10-08 13:35:09.794+07	2024-10-08 13:35:09.794+07	36b9e357-6fc2-4478-abbf-7ec493837a1a	76abbb25-8119-4a7d-80ac-a67227024bc0
a67ffe8a-4b54-4846-9ae4-455b66b2c53e	Berkas Tukin januari	2024-10-17 11:52:00+07	temporary	2026-10-17 11:53:13+07		2024-10-17 11:53:13.212+07	2024-10-17 11:53:13.212+07	58ed787d-f07c-4975-b844-8230e164be9e	7b76bc6d-411d-4b80-8346-0693d5d7160f
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refresh_tokens (id, token, last_accessed_at, created_at, updated_at, user_id) FROM stdin;
6502deba-7159-4cc9-81b2-2cd74d8790ad	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIzNmI5ZTM1Ny02ZmMyLTQ0NzgtYWJiZi03ZWM0OTM4MzdhMWEiLCJpYXQiOjE3MjgzNjkwMzUsImlzcyI6IkFyc2lwIERpZ2l0YWwgUlJJIFBhbGVtYmFuZyJ9.-Dn1S1qyH78bprPfBckQFldz8avYxumwrvsUY6t4FFg	2024-10-09 07:59:37.791+07	2024-10-08 13:30:35.544+07	2024-10-09 07:59:37.794+07	36b9e357-6fc2-4478-abbf-7ec493837a1a
\.


--
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reports (id, title, description, created_at, updated_at, created_by, scope_id) FROM stdin;
074dca34-f818-4c80-a927-be1e6824c4bb	Rekap Laporan Hadi		2024-10-09 09:24:32.505+07	2024-10-09 09:24:32.505+07	ca18e670-0eff-4997-8cf0-507297a137b4	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
cf506b18-a394-4bf3-af08-7b86805053db	Rekap Tukin januari		2024-10-17 11:54:10.424+07	2024-10-17 11:54:10.424+07	58ed787d-f07c-4975-b844-8230e164be9e	3117c14f-d24a-4b6b-8710-2e73d8acfcca
\.


--
-- Data for Name: reset_password_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reset_password_requests (id, expired_at, created_at, updated_at, user_id) FROM stdin;
\.


--
-- Data for Name: scopes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scopes (id, name, level, created_at, updated_at, ancestor_id) FROM stdin;
b55fdfe2-a164-464c-a1c2-2567c56f1dd7	RRI Palembang	0	2024-10-01 13:17:40.546+07	2024-10-01 13:17:40.546+07	\N
af381477-1123-4852-9c32-1f542bfaf7b6	Bagian Tata Usaha	1	2024-10-01 13:18:38.192+07	2024-10-01 13:18:38.192+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
4ca0a951-86e2-40df-90c4-40d900f85da9	Bidang Programa Siaran	1	2024-10-01 14:51:00.703+07	2024-10-01 14:51:00.703+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
815a6644-46ee-4267-bd3d-b06067e80b2e	Bidang Pemberitaan	1	2024-10-01 14:51:21.591+07	2024-10-01 14:51:21.591+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
f0eb73df-0400-4169-bc47-49c4633790a6	Bidang Teknik Media Baru	1	2024-10-01 14:51:42.782+07	2024-10-01 14:51:42.782+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
a9a67045-ad6b-4543-98cb-88ddaaacd6be	Bidang Layanan Pengembangan Usaha	1	2024-10-01 14:52:02.77+07	2024-10-01 14:52:02.77+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
c7e59b55-f135-4de4-ad4f-ea8d26e76574	Subbagian Keuangan	2	2024-10-01 14:52:48.811+07	2024-10-01 14:52:48.811+07	af381477-1123-4852-9c32-1f542bfaf7b6
77abd0a0-9b86-445a-ac6a-debc7276a9b8	Subbagian Umum	2	2024-10-01 14:53:02.618+07	2024-10-01 14:53:02.618+07	af381477-1123-4852-9c32-1f542bfaf7b6
3117c14f-d24a-4b6b-8710-2e73d8acfcca	Subbagian SDM	2	2024-10-01 14:53:17.473+07	2024-10-01 14:53:17.473+07	af381477-1123-4852-9c32-1f542bfaf7b6
44e3df5f-aead-4d4d-be86-4e69035ca6b6	Seksi Transmisi dan Distribusi	2	2024-10-01 14:53:55.867+07	2024-10-01 14:53:55.867+07	f0eb73df-0400-4169-bc47-49c4633790a6
6f5e7c94-b5b6-43fc-8a35-5608295e957f	Seksi Teknik Studio dan Media Baru	2	2024-10-01 14:54:34.482+07	2024-10-01 14:54:34.482+07	f0eb73df-0400-4169-bc47-49c4633790a6
450fc01e-0ada-4c38-9234-932cfb171f95	Seksi Teknik Sarana dan Prasarana Penyiaran	2	2024-10-01 14:54:57.569+07	2024-10-01 14:54:57.569+07	f0eb73df-0400-4169-bc47-49c4633790a6
ea22f8f1-9b8f-425c-b2b4-0d40582a5630	Seksi Layanan Publik	2	2024-10-01 16:11:28.789+07	2024-10-01 16:11:28.789+07	a9a67045-ad6b-4543-98cb-88ddaaacd6be
9064f4e3-dbf2-4f62-b073-7e9f1ecbaa4e	Seksi Komunikasi Publik	2	2024-10-01 16:11:50.045+07	2024-10-01 16:11:50.045+07	a9a67045-ad6b-4543-98cb-88ddaaacd6be
3744af02-16e8-43f4-9bc4-e9a9538b944d	Seksi Perencanaan dan Evaluasi Program	2	2024-10-01 16:12:36.269+07	2024-10-01 16:12:36.269+07	4ca0a951-86e2-40df-90c4-40d900f85da9
ae9c0ed3-d9e1-4ab0-97f6-bd24e43e8a09	Seksi Programa 1	2	2024-10-01 16:13:20.601+07	2024-10-01 16:13:20.601+07	4ca0a951-86e2-40df-90c4-40d900f85da9
f4254e16-76f7-464b-8849-2733f87635f3	Seksi Programa 2	2	2024-10-01 16:13:35.762+07	2024-10-01 16:13:35.762+07	4ca0a951-86e2-40df-90c4-40d900f85da9
64f7977e-1419-4a70-a44c-48b887998f1b	Seksi Programa 3	2	2024-10-01 16:13:48.906+07	2024-10-01 16:13:48.906+07	4ca0a951-86e2-40df-90c4-40d900f85da9
946ff801-4720-4292-b21e-fe3c0d53a4b2	Seksi Pengembangan Berita	2	2024-10-01 16:15:01.006+07	2024-10-01 16:15:01.006+07	815a6644-46ee-4267-bd3d-b06067e80b2e
2e8e47f0-54e9-493e-8280-551e341e92e3	Seksi Layanan dan Pengembangan Usaha	2	2024-10-01 16:11:12.963+07	2024-10-01 16:15:33.627+07	a9a67045-ad6b-4543-98cb-88ddaaacd6be
732c4e63-1baa-407c-beb7-9a403b88cdeb	Seksi Olahraga	2	2024-10-01 16:16:08.119+07	2024-10-01 16:16:08.119+07	815a6644-46ee-4267-bd3d-b06067e80b2e
1c7fd132-bf1a-421f-8151-6183aead8e60	Seksi Reportase	2	2024-10-01 16:16:26.412+07	2024-10-01 16:16:26.412+07	815a6644-46ee-4267-bd3d-b06067e80b2e
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, email, password, role, name, created_at, updated_at, scope_id) FROM stdin;
58ed787d-f07c-4975-b844-8230e164be9e	oktavz76	oktavzulkarnain@gmail.com	$2b$10$wSpNp84IhO46bHIGEdozPe0j7OmUNYd9oJSQ.i/UnfDYfEZESJ.9e	staff	Oktav Zulkarnain	2024-10-01 16:19:25.611+07	2024-10-01 16:19:25.611+07	3117c14f-d24a-4b6b-8710-2e73d8acfcca
560f8b9e-58dc-4d56-a7f2-f5086152b397	rafli123	rafliumum@gmail.com	$2b$10$52XpuAieLdctaoRmGkzAYezHkt1mi/.H3T0WD93tB92PpYun4Ldp2	staff	Rafli Umum	2024-10-02 07:42:08.485+07	2024-10-02 07:44:41.673+07	77abd0a0-9b86-445a-ac6a-debc7276a9b8
ca18e670-0eff-4997-8cf0-507297a137b4	root	root@root.root	$2b$10$hodxaZsU4sfyzUUWmEL3i.vzRt1vGd6k9Re/WGKwwMeVuI3i9q4UC	root	AdminRRI_PLB	2024-10-01 13:17:40.652+07	2024-10-02 14:47:22.364+07	b55fdfe2-a164-464c-a1c2-2567c56f1dd7
0c5ae205-63e8-41aa-86bc-7e68080a9744	mei123	meisiswi@gmail.com	$2b$10$izqySPBbNZLsDnGXI2Q4PuCEv.WTq1Zncp6rNFYzPvN2z205YbWa2	staff	meisiswi	2024-10-08 12:58:40.339+07	2024-10-08 12:58:40.339+07	af381477-1123-4852-9c32-1f542bfaf7b6
36b9e357-6fc2-4478-abbf-7ec493837a1a	hadi123	hadikeu@gmail.com	$2b$10$7R3zdLFWXIidTtVdH63/Sennfwdz/9h1tn7PC/Xb54S4C4HlLA7xK	staff	Hadi	2024-10-08 12:57:00.467+07	2024-10-17 09:38:53.796+07	c7e59b55-f135-4de4-ad4f-ea8d26e76574
\.


--
-- Name: archive_codes archive_codes_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.archive_codes
    ADD CONSTRAINT archive_codes_code_key UNIQUE (code);


--
-- Name: archive_codes archive_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.archive_codes
    ADD CONSTRAINT archive_codes_pkey PRIMARY KEY (id);


--
-- Name: archive_files archive_files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.archive_files
    ADD CONSTRAINT archive_files_pkey PRIMARY KEY (id);


--
-- Name: archives archives_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.archives
    ADD CONSTRAINT archives_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_key UNIQUE (token);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: reset_password_requests reset_password_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reset_password_requests
    ADD CONSTRAINT reset_password_requests_pkey PRIMARY KEY (id);


--
-- Name: scopes scopes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scopes
    ADD CONSTRAINT scopes_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: archive_codes archive_codes_scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.archive_codes
    ADD CONSTRAINT archive_codes_scope_id_fkey FOREIGN KEY (scope_id) REFERENCES public.scopes(id) ON UPDATE CASCADE;


--
-- Name: archive_files archive_files_archive_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.archive_files
    ADD CONSTRAINT archive_files_archive_id_fkey FOREIGN KEY (archive_id) REFERENCES public.archives(id) ON UPDATE CASCADE;


--
-- Name: archives archives_archive_code_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.archives
    ADD CONSTRAINT archives_archive_code_id_fkey FOREIGN KEY (archive_code_id) REFERENCES public.archive_codes(id) ON UPDATE CASCADE;


--
-- Name: archives archives_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.archives
    ADD CONSTRAINT archives_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: refresh_tokens refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE;


--
-- Name: reports reports_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: reports reports_scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_scope_id_fkey FOREIGN KEY (scope_id) REFERENCES public.scopes(id) ON UPDATE CASCADE;


--
-- Name: reset_password_requests reset_password_requests_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reset_password_requests
    ADD CONSTRAINT reset_password_requests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE;


--
-- Name: scopes scopes_ancestor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scopes
    ADD CONSTRAINT scopes_ancestor_id_fkey FOREIGN KEY (ancestor_id) REFERENCES public.scopes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: users users_scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_scope_id_fkey FOREIGN KEY (scope_id) REFERENCES public.scopes(id) ON UPDATE CASCADE;


--
-- PostgreSQL database dump complete
--

