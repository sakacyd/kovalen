-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.keep-alive (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  name text DEFAULT ''::text,
  random uuid DEFAULT gen_random_uuid(),
  CONSTRAINT keep-alive_pkey PRIMARY KEY (id)
);
CREATE TABLE public.users (
  id uuid NOT NULL,
  email character varying UNIQUE,
  full_name character varying,
  avatar_url text,
  semester smallint,
  latitude double precision,
  longitude double precision,
  last_location_update timestamp with time zone,
  gpa numeric,
  university_id uuid,
  study_program_id uuid,
  gender character varying CHECK (gender::text = ANY (ARRAY['Laki-laki'::character varying, 'Perempuan'::character varying]::text[])),
  tujuan_belajar character varying CHECK (tujuan_belajar::text = ANY (ARRAY['Persiapan UTS'::character varying, 'Nugas sehari-hari atau mingguan'::character varying, 'Skripsi/Tugas Akhir'::character varying, 'Lain-lain'::character varying]::text[])),
  gaya_belajar character varying CHECK (gaya_belajar::text = ANY (ARRAY['Online'::character varying, 'Offline'::character varying]::text[])),
  max_distance_preference double precision DEFAULT 15.0,
  role character varying NOT NULL DEFAULT 'pelanggan'::character varying CHECK (role::text = ANY (ARRAY['owner'::character varying, 'admin'::character varying, 'pelanggan'::character varying]::text[])),
  rating_score numeric DEFAULT 0.0,
  rating_count integer DEFAULT 0,
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
CREATE TABLE public.interests (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name character varying NOT NULL UNIQUE,
  created_at timestamp with time zone DEFAULT now(),
  category_id uuid NOT NULL,
  CONSTRAINT interests_pkey PRIMARY KEY (id),
  CONSTRAINT interests_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.interest_categories(id)
);
CREATE TABLE public.user_interests (
  user_id uuid NOT NULL,
  interest_id uuid NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT user_interests_pkey PRIMARY KEY (user_id, interest_id),
  CONSTRAINT user_interests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id),
  CONSTRAINT user_interests_interest_id_fkey FOREIGN KEY (interest_id) REFERENCES public.interests(id)
);
CREATE TABLE public.swipes (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  swiper_id uuid NOT NULL,
  swiped_id uuid NOT NULL,
  is_liked boolean NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT swipes_pkey PRIMARY KEY (id),
  CONSTRAINT swipes_swiper_id_fkey FOREIGN KEY (swiper_id) REFERENCES public.users(id),
  CONSTRAINT swipes_swiped_id_fkey FOREIGN KEY (swiped_id) REFERENCES public.users(id)
);
CREATE TABLE public.matches (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user1_id uuid NOT NULL,
  user2_id uuid NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT matches_pkey PRIMARY KEY (id),
  CONSTRAINT matches_user1_id_fkey FOREIGN KEY (user1_id) REFERENCES public.users(id),
  CONSTRAINT matches_user2_id_fkey FOREIGN KEY (user2_id) REFERENCES public.users(id)
);
CREATE TABLE public.chat_rooms (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  type character varying NOT NULL CHECK (type::text = ANY (ARRAY['personal'::character varying, 'group'::character varying]::text[])),
  name character varying,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT chat_rooms_pkey PRIMARY KEY (id)
);
CREATE TABLE public.chat_participants (
  room_id uuid NOT NULL,
  user_id uuid NOT NULL,
  joined_at timestamp with time zone DEFAULT now(),
  CONSTRAINT chat_participants_pkey PRIMARY KEY (room_id, user_id),
  CONSTRAINT chat_participants_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.chat_rooms(id),
  CONSTRAINT chat_participants_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE public.messages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  room_id uuid NOT NULL,
  sender_id uuid NOT NULL,
  content text NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT messages_pkey PRIMARY KEY (id),
  CONSTRAINT messages_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.chat_rooms(id),
  CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id)
);
CREATE TABLE public.interest_categories (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name character varying NOT NULL UNIQUE,
  type character varying NOT NULL CHECK (type::text = ANY (ARRAY['academic'::character varying, 'non_academic'::character varying]::text[])),
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT interest_categories_pkey PRIMARY KEY (id)
);
CREATE TABLE public.group_invitations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  room_id uuid NOT NULL,
  inviter_id uuid NOT NULL,
  invitee_id uuid NOT NULL,
  status character varying NOT NULL DEFAULT 'pending'::character varying CHECK (status::text = ANY (ARRAY['pending'::character varying, 'accepted'::character varying, 'rejected'::character varying]::text[])),
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT group_invitations_pkey PRIMARY KEY (id),
  CONSTRAINT group_invitations_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.chat_rooms(id),
  CONSTRAINT group_invitations_inviter_id_fkey FOREIGN KEY (inviter_id) REFERENCES public.users(id),
  CONSTRAINT group_invitations_invitee_id_fkey FOREIGN KEY (invitee_id) REFERENCES public.users(id)
);
CREATE TABLE public.user_ratings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  rater_id uuid NOT NULL,
  ratee_id uuid NOT NULL,
  rating smallint NOT NULL CHECK (rating >= 1 AND rating <= 5),
  review text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT user_ratings_pkey PRIMARY KEY (id),
  CONSTRAINT user_ratings_rater_id_fkey FOREIGN KEY (rater_id) REFERENCES public.users(id),
  CONSTRAINT user_ratings_ratee_id_fkey FOREIGN KEY (ratee_id) REFERENCES public.users(id)
);
CREATE TABLE public.group_schedules (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  room_id uuid NOT NULL,
  title character varying NOT NULL,
  meeting_time timestamp with time zone NOT NULL,
  location_name character varying NOT NULL,
  is_completed boolean NOT NULL DEFAULT false,
  created_at timestamp with time zone DEFAULT now(),
  location_url character varying,
  created_by uuid NOT NULL,
  CONSTRAINT group_schedules_pkey PRIMARY KEY (id),
  CONSTRAINT group_schedules_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.chat_rooms(id),
  CONSTRAINT group_schedules_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id)
);
CREATE TABLE public.group_activities (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  schedule_id uuid NOT NULL UNIQUE,
  room_id uuid NOT NULL,
  activity_summary text NOT NULL,
  material_covered text,
  next_goals text,
  created_by uuid NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT group_activities_pkey PRIMARY KEY (id),
  CONSTRAINT group_activities_schedule_id_fkey FOREIGN KEY (schedule_id) REFERENCES public.group_schedules(id),
  CONSTRAINT group_activities_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.chat_rooms(id),
  CONSTRAINT group_activities_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id)
);

CREATE OR REPLACE FUNCTION public.set_activity_created_by()
RETURNS TRIGGER AS $$
BEGIN
  SELECT created_by INTO NEW.created_by
  FROM public.group_schedules
  WHERE id = NEW.schedule_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_set_activity_created_by
BEFORE INSERT ON public.group_activities
FOR EACH ROW
EXECUTE FUNCTION public.set_activity_created_by();