# Public Policies

| CREATE POLICY "Participants can create schedules" ON public.group_schedules AS PERMISSIVE FOR INSERT TO authenticated WITH CHECK ((is_room_participant(room_id) OR is_admin_or_owner())); |
| CREATE POLICY "Participants can update schedules" ON public.group_schedules AS PERMISSIVE FOR UPDATE TO authenticated USING ((is_room_participant(room_id) OR is_admin_or_owner())); |
| CREATE POLICY "Participants can view schedules" ON public.group_schedules AS PERMISSIVE FOR SELECT TO authenticated USING ((is_room_participant(room_id) OR is_admin_or_owner())); |
| CREATE POLICY "Enable read access for all users" ON public.universities AS PERMISSIVE FOR SELECT TO public USING (true); |
| CREATE POLICY "Admin Owner can update all users" ON public.users AS PERMISSIVE FOR UPDATE TO authenticated USING (is_admin_or_owner()); |
| CREATE POLICY "Admin Owner can view all users" ON public.users AS PERMISSIVE FOR SELECT TO authenticated USING (is_admin_or_owner()); |
| CREATE POLICY "Enable insert access" ON public.users AS PERMISSIVE FOR INSERT TO public WITH CHECK (true); |
| CREATE POLICY "Enable read access for all users" ON public.users AS PERMISSIVE FOR SELECT TO public USING (true); |
| CREATE POLICY "Enable update access for their own profile" ON public.users AS PERMISSIVE FOR UPDATE TO public USING ((auth.uid() = id)); |

| CREATE POLICY "Owner can delete users" ON public.users AS PERMISSIVE FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
FROM users users_1
WHERE ((users_1.id = auth.uid()) AND ((users_1.role)::text = 'owner'::text))))); |
| CREATE POLICY "Admin Owner can view all chat rooms" ON public.chat_rooms AS PERMISSIVE FOR SELECT TO authenticated USING (is_admin_or_owner()); |
| CREATE POLICY "Allow participants to update chat_rooms" ON public.chat_rooms AS PERMISSIVE FOR UPDATE TO public USING ((EXISTS ( SELECT 1
FROM chat_participants
WHERE ((chat_participants.room_id = chat_rooms.id) AND (chat_participants.user_id = auth.uid()))))) WITH CHECK ((EXISTS ( SELECT 1
FROM chat_participants
WHERE ((chat_participants.room_id = chat_rooms.id) AND (chat_participants.user_id = auth.uid()))))); |
| CREATE POLICY "Users can view their chat rooms" ON public.chat_rooms AS PERMISSIVE FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
FROM chat_participants
WHERE ((chat_participants.room_id = chat_rooms.id) AND (chat_participants.user_id = auth.uid()))))); |
| CREATE POLICY "Admin Owner can view all messages" ON public.messages AS PERMISSIVE FOR SELECT TO authenticated USING (is_admin_or_owner()); |
| CREATE POLICY "Users can insert messages to their rooms" ON public.messages AS PERMISSIVE FOR INSERT TO authenticated WITH CHECK (((auth.uid() = sender_id) AND (EXISTS ( SELECT 1
FROM chat_participants
WHERE ((chat_participants.room_id = messages.room_id) AND (chat_participants.user_id = auth.uid())))))); |
| CREATE POLICY "Users can read messages in their rooms" ON public.messages AS PERMISSIVE FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
FROM chat_participants
WHERE ((chat_participants.room_id = messages.room_id) AND (chat_participants.user_id = auth.uid()))))); |
| CREATE POLICY "Admin Owner can view all chat participants" ON public.chat_participants AS PERMISSIVE FOR SELECT TO authenticated USING (is_admin_or_owner()); |
| CREATE POLICY "Users can insert chat participants on their own rooms" ON public.chat_participants AS PERMISSIVE FOR INSERT TO public WITH CHECK (((user_id = auth.uid()) OR (EXISTS ( SELECT 1
FROM chat_participants cp
WHERE ((cp.room_id = chat_participants.room_id) AND (cp.user_id = auth.uid())))))); |
| CREATE POLICY "Users can view chat participants of their rooms" ON public.chat_participants AS PERMISSIVE FOR SELECT TO authenticated USING (((user_id = auth.uid()) OR is_room_participant(room_id))); |
| CREATE POLICY "Enable read access for all users" ON public.study_programs AS PERMISSIVE FOR SELECT TO public USING (true); |
| CREATE POLICY "Enable insert for users based on user_id" ON public.user_interests AS PERMISSIVE FOR INSERT TO public WITH CHECK ((( SELECT auth.uid() AS uid) = user_id)); |
| CREATE POLICY "Enable read access for all users" ON public.user_interests AS PERMISSIVE FOR SELECT TO public USING (true); |
| CREATE POLICY "Enable update for users based on user_id" ON public.user_interests AS PERMISSIVE FOR UPDATE TO authenticated USING ((( SELECT auth.uid() AS uid) = user_id)) WITH CHECK ((( SELECT auth.uid() AS uid) = user_id)); |
| CREATE POLICY "Enable insert for users" ON public.swipes AS PERMISSIVE FOR INSERT TO public WITH CHECK (true); |
| CREATE POLICY "Enable insert for users based on swiper_id" ON public.swipes AS PERMISSIVE FOR INSERT TO public WITH CHECK ((( SELECT auth.uid() AS uid) = swiper_id)); |
| CREATE POLICY "Enable select for users based on swiper_id" ON public.swipes AS PERMISSIVE FOR SELECT TO public USING ((auth.uid() = swiper_id)); |
| CREATE POLICY "Enable read access for all users" ON public.interest_categories AS PERMISSIVE FOR SELECT TO public USING (true); |
| CREATE POLICY "Enable read access for all users" ON public.interests AS PERMISSIVE FOR SELECT TO public USING (true); |
| CREATE POLICY "Users can view their own matches" ON public.matches AS PERMISSIVE FOR SELECT TO authenticated USING (((user1_id = auth.uid()) OR (user2_id = auth.uid()))); |
| CREATE POLICY "Users can see their own invitations" ON public.group_invitations AS PERMISSIVE FOR SELECT TO authenticated USING (((inviter_id = auth.uid()) OR (invitee_id = auth.uid()))); |
| CREATE POLICY "Participants can create activities" ON public.group_activities AS PERMISSIVE FOR INSERT TO authenticated WITH CHECK (((auth.uid() = created_by) AND (is_room_participant(room_id) OR is_admin_or_owner()))); |
| CREATE POLICY "Participants can view activities" ON public.group_activities AS PERMISSIVE FOR SELECT TO authenticated USING ((is_room_participant(room_id) OR is_admin_or_owner())); |
| CREATE POLICY "Everyone can read ratings" ON public.user_ratings AS PERMISSIVE FOR SELECT TO authenticated USING (true); |
| CREATE POLICY "Users can insert rating if they have matched" ON public.user_ratings AS PERMISSIVE FOR INSERT TO authenticated WITH CHECK (((auth.uid() = rater_id) AND (EXISTS ( SELECT 1
FROM matches
WHERE (((matches.user1_id = auth.uid()) AND (matches.user2_id = user_ratings.ratee_id)) OR ((matches.user2_id = auth.uid()) AND (matches.user1_id = user_ratings.ratee_id))))))); |

# Realtime Policies

| CREATE POLICY "Allow listening for broadcasts for authenticated users only" ON realtime.messages AS PERMISSIVE FOR SELECT TO authenticated USING (true); |
| CREATE POLICY "Allow pushing broadcasts for authenticated users only" ON realtime.messages AS PERMISSIVE FOR INSERT TO authenticated WITH CHECK (true); |

# Storage Policies

| CREATE POLICY "Authenticated users can access avatar images 1oj01fe_0" ON storage.objects AS PERMISSIVE FOR SELECT TO authenticated USING ((bucket_id = 'avatars'::text));      |
| CREATE POLICY "Authenticated users can upload avatar images 1oj01fe_0" ON storage.objects AS PERMISSIVE FOR INSERT TO authenticated WITH CHECK ((bucket_id = 'avatars'::text)); |

# Public Functions

| CREATE OR REPLACE FUNCTION public.handle_new_group_participant()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
invited_name text;
msg_content text;
room_type text;
BEGIN
-- Cek tipe room, kita HANYA ingin pesan sistem ini muncul di 'group', bukan di 'personal'
SELECT type INTO room_type FROM public.chat_rooms WHERE id = NEW.room_id;

IF room_type = 'group' THEN
-- Dapatkan nama user yang baru bergabung
SELECT full_name INTO invited_name FROM public.users WHERE id = NEW.user_id;
-- Tentukan siapa yang melakukan aksi (berdasarkan auth.uid())
IF auth.uid() = NEW.user_id THEN
msg_content := 'bergabung ke dalam grup';
ELSE
msg_content := 'menambahkan ' || invited_name || ' ke dalam grup';
END IF;
-- Insert pesan sistem
INSERT INTO public.messages (room_id, sender_id, content, is_system_message)
VALUES (
NEW.room_id,
COALESCE(auth.uid(), NEW.user_id),
msg_content,
true
);
END IF;
RETURN NEW;
END;
$function$
; |


| CREATE OR REPLACE FUNCTION public.handle_update_group_profile()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
BEGIN
-- Hanya proses jika room type adalah group
IF NEW.type = 'group' THEN
-- Cek perubahan nama
IF OLD.name IS DISTINCT FROM NEW.name THEN
INSERT INTO public.messages (room_id, sender_id, content, is_system_message)
VALUES (
NEW.id,
auth.uid(),
'mengubah nama grup menjadi "' || NEW.name || '"',
true
);
END IF;
-- Cek perubahan foto profil / avatar
IF OLD.avatar_url IS DISTINCT FROM NEW.avatar_url THEN
INSERT INTO public.messages (room_id, sender_id, content, is_system_message)
VALUES (
NEW.id,
auth.uid(),
'mengubah foto profil grup',
true
);
END IF;
END IF;
RETURN NEW;
END;
$function$
; |


| CREATE OR REPLACE FUNCTION public.is_room_participant(check_room_id uuid)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
BEGIN
RETURN EXISTS (
SELECT 1 FROM public.chat_participants
WHERE room_id = check_room_id
AND user_id = auth.uid()
);
END;
$function$
; |


| CREATE OR REPLACE FUNCTION public.set_activity_created_by()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
BEGIN
-- Mengambil created_by dari tabel group_schedules yang berelasi
SELECT created_by INTO NEW.created_by
FROM public.group_schedules
WHERE id = NEW.schedule_id;

RETURN NEW;
END;
$function$
; |


| CREATE OR REPLACE FUNCTION public.is_admin_or_owner()
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
BEGIN
RETURN EXISTS (
SELECT 1 FROM public.users
WHERE id = auth.uid() AND role IN ('admin', 'owner')
);
END;
$function$
; |


| CREATE OR REPLACE FUNCTION public.update_user_rating()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
BEGIN
-- Hitung rata-rata rating dan jumlah rating untuk pengguna yang dinilai
UPDATE public.users
SET
rating_score = (
SELECT COALESCE(AVG(rating), 0.0)
FROM public.user_ratings
WHERE ratee_id = NEW.ratee_id
),
rating_count = (
SELECT COUNT(\*)
FROM public.user_ratings
WHERE ratee_id = NEW.ratee_id
)
WHERE id = NEW.ratee_id;

RETURN NEW;
END;
$function$
; |


| CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$begin
insert into public.users (id, email)
values (new.id, new.email);
return new;
end;$function$
; |


| CREATE OR REPLACE FUNCTION public.invite_to_group(p_room_id uuid, p_invitee_id uuid)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
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
$function$
; |


| CREATE OR REPLACE FUNCTION public.accept_group_invitation(p_invitation_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
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
$function$


| CREATE OR REPLACE FUNCTION public.check_and_create_match()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$DECLARE
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
END;$function$
; |


# Public Trigger

| CREATE TRIGGER trigger_create_match_on_swipe AFTER INSERT ON public.swipes FOR EACH ROW EXECUTE FUNCTION check_and_create_match();                  |
| CREATE TRIGGER trigger_update_rating AFTER INSERT OR DELETE OR UPDATE ON public.user_ratings FOR EACH ROW EXECUTE FUNCTION update_user_rating();    |
| CREATE TRIGGER trigger_set_activity_created_by BEFORE INSERT ON public.group_activities FOR EACH ROW EXECUTE FUNCTION set_activity_created_by();    |
| CREATE TRIGGER trigger_new_group_participant AFTER INSERT ON public.chat_participants FOR EACH ROW EXECUTE FUNCTION handle_new_group_participant(); |
| CREATE TRIGGER trigger_update_group_profile AFTER UPDATE ON public.chat_rooms FOR EACH ROW EXECUTE FUNCTION handle_update_group_profile();          |


# Public Indexes

| CREATE UNIQUE INDEX "keep-alive_pkey" ON public."keep-alive" USING btree (id);                                                    |
| CREATE UNIQUE INDEX group_schedules_pkey ON public.group_schedules USING btree (id);                                              |
| CREATE UNIQUE INDEX unique_active_schedule_per_room ON public.group_schedules USING btree (room_id) WHERE (is_completed = false); |
| CREATE UNIQUE INDEX universities_kode_pt_key ON public.universities USING btree (institution_code);                               |
| CREATE UNIQUE INDEX universities_pkey ON public.universities USING btree (id);                                                    |
| CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);                                                          |
| CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id);                                                                  |
| CREATE INDEX idx_users_location ON public.users USING btree (latitude, longitude);                                                |
| CREATE UNIQUE INDEX chat_rooms_pkey ON public.chat_rooms USING btree (id);                                                        |
| CREATE UNIQUE INDEX messages_pkey ON public.messages USING btree (id);                                                            |
| CREATE INDEX idx_messages_room_id ON public.messages USING btree (room_id);                                                       |
| CREATE INDEX idx_messages_created_at ON public.messages USING btree (created_at DESC);                                            |
| CREATE UNIQUE INDEX chat_participants_pkey ON public.chat_participants USING btree (room_id, user_id);                            |
| CREATE INDEX idx_chat_participants_user_id ON public.chat_participants USING btree (user_id);                                     |
| CREATE UNIQUE INDEX study_programs_pkey ON public.study_programs USING btree (id);                                                |
| CREATE UNIQUE INDEX user_interests_pkey ON public.user_interests USING btree (user_id, interest_id);                              |
| CREATE INDEX idx_user_interests_user_id ON public.user_interests USING btree (user_id);                                           |
| CREATE INDEX idx_user_interests_interest_id ON public.user_interests USING btree (interest_id);                                   |
| CREATE UNIQUE INDEX swipes_pkey ON public.swipes USING btree (id);                                                                |
| CREATE UNIQUE INDEX unique_swipe ON public.swipes USING btree (swiper_id, swiped_id);                                             |
| CREATE INDEX idx_swipes_swiper_id ON public.swipes USING btree (swiper_id);                                                       |
| CREATE INDEX idx_swipes_swiped_id ON public.swipes USING btree (swiped_id);                                                       |
| CREATE UNIQUE INDEX interest_categories_pkey ON public.interest_categories USING btree (id);                                      |
| CREATE UNIQUE INDEX interest_categories_name_key ON public.interest_categories USING btree (name);                                |
| CREATE UNIQUE INDEX interests_pkey ON public.interests USING btree (id);                                                          |
| CREATE UNIQUE INDEX interests_name_key ON public.interests USING btree (name);                                                    |
| CREATE UNIQUE INDEX matches_pkey ON public.matches USING btree (id);                                                              |
| CREATE UNIQUE INDEX unique_match ON public.matches USING btree (user1_id, user2_id);                                              |
| CREATE INDEX idx_matches_user1_id ON public.matches USING btree (user1_id);                                                       |
| CREATE INDEX idx_matches_user2_id ON public.matches USING btree (user2_id);                                                       |
| CREATE UNIQUE INDEX group_invitations_pkey ON public.group_invitations USING btree (id);                                          |
| CREATE UNIQUE INDEX group_activities_pkey ON public.group_activities USING btree (id);                                            |
| CREATE UNIQUE INDEX group_activities_schedule_id_key ON public.group_activities USING btree (schedule_id);                        |
| CREATE UNIQUE INDEX user_ratings_pkey ON public.user_ratings USING btree (id);                                                    |


# Publications

| ALTER PUBLICATION supabase_realtime ADD TABLE public.chat_participants;                          |
| ALTER PUBLICATION supabase_realtime ADD TABLE public.chat_rooms;                                 |
| ALTER PUBLICATION supabase_realtime ADD TABLE public.matches;                                    |
| ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;                                   |
| ALTER PUBLICATION supabase_realtime ADD TABLE public.users;                                      |
| ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE realtime.messages_2026_07_09; |
| ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE realtime.messages_2026_07_10; |
| ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE realtime.messages_2026_07_11; |
| ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE realtime.messages_2026_07_12; |
| ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE realtime.messages_2026_07_13; |
| ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE realtime.messages_2026_07_14; |
| ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE realtime.messages_2026_07_15; |


# Auth Triggers

| executable_sql                                                                                                  |
| --------------------------------------------------------------------------------------------------------------- |
| CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION handle_new_user(); |