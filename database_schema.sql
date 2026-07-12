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
  gender character varying CHECK (gender IN ('Laki-laki', 'Perempuan')),
  tujuan_belajar character varying CHECK (tujuan_belajar IN ('Persiapan UTS', 'Nugas sehari-hari atau mingguan', 'Skripsi/Tugas Akhir', 'Lain-lain')),
  gaya_belajar character varying CHECK (gaya_belajar IN ('Online', 'Offline')),
  max_distance_preference double precision DEFAULT 15.0,
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
-- 10. GROUP_INVITATIONS (Undangan Grup)
-- ==========================================
CREATE TABLE public.group_invitations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  room_id uuid NOT NULL,
  inviter_id uuid NOT NULL,
  invitee_id uuid NOT NULL,
  status character varying NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected')),
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT group_invitations_pkey PRIMARY KEY (id),
  CONSTRAINT group_invitations_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.chat_rooms(id) ON DELETE CASCADE,
  CONSTRAINT group_invitations_inviter_id_fkey FOREIGN KEY (inviter_id) REFERENCES public.users(id) ON DELETE CASCADE,
  CONSTRAINT group_invitations_invitee_id_fkey FOREIGN KEY (invitee_id) REFERENCES public.users(id) ON DELETE CASCADE,
  CONSTRAINT check_no_self_invite CHECK (inviter_id != invitee_id)
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
  v_user3 uuid;
  v_user4 uuid;
  v_group_room_id uuid;
  v_name1 character varying;
  v_name2 character varying;
  v_name3 character varying;
  v_name4 character varying;
  v_group_name character varying;
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
        
        -- ==========================================
        -- 4-WAY CLIQUE DETECTION (TARGETED SEARCH)
        -- ==========================================
        WITH user1_matches AS (
            SELECT CASE WHEN user1_id = v_user1 THEN user2_id ELSE user1_id END AS matched_user
            FROM public.matches WHERE user1_id = v_user1 OR user2_id = v_user1
        ),
        user2_matches AS (
            SELECT CASE WHEN user1_id = v_user2 THEN user2_id ELSE user1_id END AS matched_user
            FROM public.matches WHERE user1_id = v_user2 OR user2_id = v_user2
        ),
        common_matches AS (
            SELECT u1.matched_user
            FROM user1_matches u1
            JOIN user2_matches u2 ON u1.matched_user = u2.matched_user
        )
        SELECT c1.matched_user, c2.matched_user
        INTO v_user3, v_user4
        FROM common_matches c1
        JOIN common_matches c2 ON c1.matched_user < c2.matched_user
        JOIN public.matches m ON 
            (m.user1_id = c1.matched_user AND m.user2_id = c2.matched_user) OR 
            (m.user1_id = c2.matched_user AND m.user2_id = c1.matched_user)
        LIMIT 1;

        IF v_user3 IS NOT NULL AND v_user4 IS NOT NULL THEN
            -- Fetch first names of the 4 users
            SELECT split_part(full_name, ' ', 1) INTO v_name1 FROM public.users WHERE id = v_user1;
            SELECT split_part(full_name, ' ', 1) INTO v_name2 FROM public.users WHERE id = v_user2;
            SELECT split_part(full_name, ' ', 1) INTO v_name3 FROM public.users WHERE id = v_user3;
            SELECT split_part(full_name, ' ', 1) INTO v_name4 FROM public.users WHERE id = v_user4;
            
            v_group_name := v_name1 || ', ' || v_name2 || ', ' || v_name3 || ', ' || v_name4;

            -- 4-Clique Found! Create a group chat room with combined names
            INSERT INTO public.chat_rooms (type, name) VALUES ('group', v_group_name) RETURNING id INTO v_group_room_id;
            
            -- Insert all 4 users into the group room
            INSERT INTO public.chat_participants (room_id, user_id) VALUES (v_group_room_id, v_user1);
            INSERT INTO public.chat_participants (room_id, user_id) VALUES (v_group_room_id, v_user2);
            INSERT INTO public.chat_participants (room_id, user_id) VALUES (v_group_room_id, v_user3);
            INSERT INTO public.chat_participants (room_id, user_id) VALUES (v_group_room_id, v_user4);
        END IF;

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
-- POLICIES UNTUK MATCHES
-- ==========================================
CREATE POLICY "Users can view their own matches"
ON public.matches
FOR SELECT
TO authenticated
USING (
  user1_id = auth.uid() OR user2_id = auth.uid()
);

-- ==========================================
-- POLICIES UNTUK CHAT_ROOMS & CHAT_PARTICIPANTS
-- ==========================================
CREATE POLICY "Users can view their chat rooms"
ON public.chat_rooms
FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.chat_participants
    WHERE chat_participants.room_id = id
    AND chat_participants.user_id = auth.uid()
  )
);

-- Helper function to break infinite recursion in chat_participants
CREATE OR REPLACE FUNCTION public.is_room_participant(check_room_id uuid)
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.chat_participants
    WHERE room_id = check_room_id
    AND user_id = auth.uid()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE POLICY "Users can view chat participants of their rooms"
ON public.chat_participants
FOR SELECT
TO authenticated
USING (
  user_id = auth.uid() OR
  public.is_room_participant(room_id)
);

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

-- ==========================================
-- GROUP INVITATION RPC FUNCTIONS
-- ==========================================
CREATE OR REPLACE FUNCTION public.invite_to_group(p_room_id uuid, p_invitee_id uuid)
RETURNS uuid AS $$
DECLARE
  v_inviter_id uuid := auth.uid();
  v_is_matched boolean;
  v_invitation_id uuid;
BEGIN
  -- 1. Verify inviter is in the room
  IF NOT EXISTS (SELECT 1 FROM public.chat_participants WHERE room_id = p_room_id AND user_id = v_inviter_id) THEN
    RAISE EXCEPTION 'You are not a participant of this room.';
  END IF;

  -- 2. Verify inviter and invitee are matched
  SELECT EXISTS (
    SELECT 1 FROM public.matches 
    WHERE (user1_id = v_inviter_id AND user2_id = p_invitee_id)
       OR (user1_id = p_invitee_id AND user2_id = v_inviter_id)
  ) INTO v_is_matched;

  IF NOT v_is_matched THEN
    RAISE EXCEPTION 'You can only invite users you have matched with.';
  END IF;
  
  -- 3. Verify room is a group room
  IF NOT EXISTS (SELECT 1 FROM public.chat_rooms WHERE id = p_room_id AND type = 'group') THEN
    RAISE EXCEPTION 'Invitations can only be sent for group rooms.';
  END IF;

  -- 4. Check if already invited or already in room
  IF EXISTS (SELECT 1 FROM public.chat_participants WHERE room_id = p_room_id AND user_id = p_invitee_id) THEN
    RAISE EXCEPTION 'User is already in the room.';
  END IF;

  IF EXISTS (SELECT 1 FROM public.group_invitations WHERE room_id = p_room_id AND invitee_id = p_invitee_id AND status = 'pending') THEN
    RAISE EXCEPTION 'User already has a pending invitation for this room.';
  END IF;

  INSERT INTO public.group_invitations (room_id, inviter_id, invitee_id)
  VALUES (p_room_id, v_inviter_id, p_invitee_id)
  RETURNING id INTO v_invitation_id;

  RETURN v_invitation_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.accept_group_invitation(p_invitation_id uuid)
RETURNS void AS $$
DECLARE
  v_invitee_id uuid := auth.uid();
  v_room_id uuid;
  v_status varchar;
BEGIN
  SELECT room_id, status INTO v_room_id, v_status
  FROM public.group_invitations
  WHERE id = p_invitation_id AND invitee_id = v_invitee_id;

  IF v_room_id IS NULL THEN
    RAISE EXCEPTION 'Invitation not found or you are not the invitee.';
  END IF;

  IF v_status != 'pending' THEN
    RAISE EXCEPTION 'Invitation is no longer pending.';
  END IF;

  -- Update status
  UPDATE public.group_invitations
  SET status = 'accepted'
  WHERE id = p_invitation_id;

  -- Add to participants
  INSERT INTO public.chat_participants (room_id, user_id)
  VALUES (v_room_id, v_invitee_id)
  ON CONFLICT DO NOTHING;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==========================================
-- POLICIES UNTUK GROUP INVITATIONS
-- ==========================================
ALTER TABLE public.group_invitations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can see their own invitations"
ON public.group_invitations
FOR SELECT
TO authenticated
USING (
  inviter_id = auth.uid() OR invitee_id = auth.uid()
);
