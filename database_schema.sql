-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==========================================
-- 1. UNIVERSITAS & PROGRAM STUDI (Reference Data)
-- ==========================================
CREATE TABLE public.universities (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  institution_code character varying NOT NULL UNIQUE,
  name character varying NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT universities_pkey PRIMARY KEY (id)
);

CREATE TABLE public.study_programs (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  university_id uuid NOT NULL,
  program_code character varying NOT NULL,
  name character varying NOT NULL,
  education_level character varying NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT study_programs_pkey PRIMARY KEY (id),
  CONSTRAINT study_programs_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(id) ON DELETE CASCADE
);

-- ==========================================
-- 2. USERS (Profil dan Akademik)
-- ==========================================
CREATE TABLE public.users (
  id uuid NOT NULL, -- References auth.users
  email character varying UNIQUE NOT NULL,
  full_name character varying NOT NULL,
  avatar_url text,
  semester smallint NOT NULL,
  latitude double precision,
  longitude double precision,
  last_location_update timestamp with time zone,
  gpa numeric,
  university_id uuid,
  study_program_id uuid,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT users_pkey PRIMARY KEY (id),
  CONSTRAINT users_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE,
  CONSTRAINT users_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(id) ON DELETE SET NULL,
  CONSTRAINT users_study_program_id_fkey FOREIGN KEY (study_program_id) REFERENCES public.study_programs(id) ON DELETE SET NULL
);

-- ==========================================
-- 3. INTERESTS (Master Minat & Kategori)
-- ==========================================
CREATE TABLE public.interest_categories (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name character varying NOT NULL UNIQUE,
  type character varying NOT NULL CHECK (type IN ('academic', 'non_academic')),
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT interest_categories_pkey PRIMARY KEY (id)
);

CREATE TABLE public.interests (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  category_id uuid NOT NULL,
  name character varying NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT interests_pkey PRIMARY KEY (id),
  CONSTRAINT interests_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.interest_categories(id) ON DELETE CASCADE
);

-- ==========================================
-- 4. USER_INTERESTS (Relasi Mahasiswa & Minat)
-- ==========================================
CREATE TABLE public.user_interests (
  user_id uuid NOT NULL,
  interest_id uuid NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT user_interests_pkey PRIMARY KEY (user_id, interest_id),
  CONSTRAINT user_interests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE,
  CONSTRAINT user_interests_interest_id_fkey FOREIGN KEY (interest_id) REFERENCES public.interests(id) ON DELETE CASCADE
);

-- ==========================================
-- 5. SWIPES (Riwayat Interaksi)
-- ==========================================
CREATE TABLE public.swipes (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  swiper_id uuid NOT NULL,
  swiped_id uuid NOT NULL,
  is_liked boolean NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT swipes_pkey PRIMARY KEY (id),
  CONSTRAINT swipes_swiper_id_fkey FOREIGN KEY (swiper_id) REFERENCES public.users(id) ON DELETE CASCADE,
  CONSTRAINT swipes_swiped_id_fkey FOREIGN KEY (swiped_id) REFERENCES public.users(id) ON DELETE CASCADE,
  CONSTRAINT unique_swipe UNIQUE (swiper_id, swiped_id)
);

-- ==========================================
-- 6. MATCHES (Koneksi)
-- ==========================================
CREATE TABLE public.matches (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user1_id uuid NOT NULL,
  user2_id uuid NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT matches_pkey PRIMARY KEY (id),
  CONSTRAINT matches_user1_id_fkey FOREIGN KEY (user1_id) REFERENCES public.users(id) ON DELETE CASCADE,
  CONSTRAINT matches_user2_id_fkey FOREIGN KEY (user2_id) REFERENCES public.users(id) ON DELETE CASCADE,
  CONSTRAINT check_user_order CHECK (user1_id < user2_id),
  CONSTRAINT unique_match UNIQUE (user1_id, user2_id)
);

-- ==========================================
-- 7. CHAT_ROOMS (Ruang Obrolan)
-- ==========================================
CREATE TABLE public.chat_rooms (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  type character varying NOT NULL CHECK (type IN ('personal', 'group')),
  name character varying, -- Nullable, used for group chats
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT chat_rooms_pkey PRIMARY KEY (id)
);

-- ==========================================
-- 8. CHAT_PARTICIPANTS (Anggota Ruang Obrolan)
-- ==========================================
CREATE TABLE public.chat_participants (
  room_id uuid NOT NULL,
  user_id uuid NOT NULL,
  joined_at timestamp with time zone DEFAULT now(),
  CONSTRAINT chat_participants_pkey PRIMARY KEY (room_id, user_id),
  CONSTRAINT chat_participants_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.chat_rooms(id) ON DELETE CASCADE,
  CONSTRAINT chat_participants_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE
);

-- ==========================================
-- 9. MESSAGES (Pesan)
-- ==========================================
CREATE TABLE public.messages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  room_id uuid NOT NULL,
  sender_id uuid NOT NULL,
  content text NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT messages_pkey PRIMARY KEY (id),
  CONSTRAINT messages_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.chat_rooms(id) ON DELETE CASCADE,
  CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id) ON DELETE CASCADE
);

-- ==========================================
-- INDEXES FOR PERFORMANCE
-- ==========================================
CREATE INDEX idx_users_location ON public.users(latitude, longitude);
CREATE INDEX idx_user_interests_user_id ON public.user_interests(user_id);
CREATE INDEX idx_user_interests_interest_id ON public.user_interests(interest_id);
CREATE INDEX idx_swipes_swiper_id ON public.swipes(swiper_id);
CREATE INDEX idx_swipes_swiped_id ON public.swipes(swiped_id);
CREATE INDEX idx_matches_user1_id ON public.matches(user1_id);
CREATE INDEX idx_matches_user2_id ON public.matches(user2_id);
CREATE INDEX idx_chat_participants_user_id ON public.chat_participants(user_id);
CREATE INDEX idx_messages_room_id ON public.messages(room_id);
CREATE INDEX idx_messages_created_at ON public.messages(created_at DESC);

-- ==========================================
-- TRIGGERS & FUNCTIONS
-- ==========================================

-- Trigger Function: Check for Match when a swipe occurs
CREATE OR REPLACE FUNCTION public.check_and_create_match()
RETURNS TRIGGER AS $$
DECLARE
  v_user1 uuid;
  v_user2 uuid;
  v_match_exists boolean;
  v_room_id uuid;
BEGIN
  -- Only proceed if it's a right swipe (is_liked = true)
  IF NEW.is_liked = true THEN
    -- Check if the other user has already swiped right on this user
    IF EXISTS (
      SELECT 1 FROM public.swipes
      WHERE swiper_id = NEW.swiped_id
        AND swiped_id = NEW.swiper_id
        AND is_liked = true
    ) THEN
      -- Determine user1_id and user2_id based on alphabetical order to maintain consistency
      IF NEW.swiper_id < NEW.swiped_id THEN
        v_user1 := NEW.swiper_id;
        v_user2 := NEW.swiped_id;
      ELSE
        v_user1 := NEW.swiped_id;
        v_user2 := NEW.swiper_id;
      END IF;

      -- Check if match already exists to prevent duplicate matches
      SELECT EXISTS (
        SELECT 1 FROM public.matches 
        WHERE user1_id = v_user1 AND user2_id = v_user2
      ) INTO v_match_exists;

      IF NOT v_match_exists THEN
        -- Insert new match
        INSERT INTO public.matches (user1_id, user2_id)
        VALUES (v_user1, v_user2);
        
        -- Automatically create a personal chat room for the matched users
        INSERT INTO public.chat_rooms (type) VALUES ('personal') RETURNING id INTO v_room_id;
        
        -- Add both users as participants
        INSERT INTO public.chat_participants (room_id, user_id) VALUES (v_room_id, v_user1);
        INSERT INTO public.chat_participants (room_id, user_id) VALUES (v_room_id, v_user2);
      END IF;
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_create_match_on_swipe ON public.swipes;
CREATE TRIGGER trigger_create_match_on_swipe
AFTER INSERT ON public.swipes
FOR EACH ROW
EXECUTE FUNCTION public.check_and_create_match();


-- ==========================================
-- ROW LEVEL SECURITY (RLS)
-- ==========================================
-- Enable RLS on all tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_interests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.swipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chat_rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chat_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- ==========================================
-- POLICIES UNTUK PUBLIC.MESSAGES (REALTIME CHAT)
-- ==========================================
-- Policy: Pengguna hanya dapat MEMBACA pesan di ruang chat yang mereka ikuti
CREATE POLICY "Users can read messages in their rooms"
ON public.messages
FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.chat_participants
    WHERE chat_participants.room_id = messages.room_id
    AND chat_participants.user_id = auth.uid()
  )
);

-- Policy: Pengguna hanya dapat MENGIRIM pesan jika mereka adalah partisipan di ruang tersebut
CREATE POLICY "Users can insert messages to their rooms"
ON public.messages
FOR INSERT
TO authenticated
WITH CHECK (
  auth.uid() = sender_id AND
  EXISTS (
    SELECT 1 FROM public.chat_participants
    WHERE chat_participants.room_id = messages.room_id
    AND chat_participants.user_id = auth.uid()
  )
);
