CREATE TABLE public.users (
  id uuid NOT NULL,
  email character varying UNIQUE,
  full_name character varying,
  avatar_url text,
  semester smallint,
  latitude double precision,
  longtitude double precision,
  last_location_update timestamp with time zone,
  gpa numeric,
  university_id uuid,
  study_program_id uuid,
  CONSTRAINT users_pkey PRIMARY KEY (id),
  CONSTRAINT users_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id),
  CONSTRAINT users_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(id),
  CONSTRAINT users_study_program_id_fkey FOREIGN KEY (study_program_id) REFERENCES public.study_programs(id)
);

CREATE TABLE public.universities (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  institution_code character varying NOT NULL UNIQUE,
  name character varying NOT NULL,
  CONSTRAINT universities_pkey PRIMARY KEY (id)
);

CREATE TABLE public.study_programs (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  university_id uuid NOT NULL,
  program_code character varying NOT NULL,
  name character varying NOT NULL,
  education_level character varying NOT NULL,
  CONSTRAINT study_programs_pkey PRIMARY KEY (id),
  CONSTRAINT study_programs_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(id)
);
