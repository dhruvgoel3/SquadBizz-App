-- ============================================================
-- SquadBizz: Polls Schema
-- Run in: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- 1. Polls table
CREATE TABLE IF NOT EXISTS public.polls (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  room_id     UUID NOT NULL REFERENCES public.rooms(id) ON DELETE CASCADE,
  created_by  UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  question    TEXT NOT NULL,
  poll_type   TEXT NOT NULL DEFAULT 'single',   -- 'single' or 'multi'
  is_anonymous BOOLEAN NOT NULL DEFAULT false,
  expires_at  TIMESTAMPTZ,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Poll options table
CREATE TABLE IF NOT EXISTS public.poll_options (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  poll_id     UUID NOT NULL REFERENCES public.polls(id) ON DELETE CASCADE,
  text        TEXT NOT NULL,
  sort_order  INT NOT NULL DEFAULT 0
);

-- 3. Poll votes table
CREATE TABLE IF NOT EXISTS public.poll_votes (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  poll_id         UUID NOT NULL REFERENCES public.polls(id) ON DELETE CASCADE,
  poll_option_id  UUID NOT NULL REFERENCES public.poll_options(id) ON DELETE CASCADE,
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(poll_id, poll_option_id, user_id)
);

-- 4. Enable RLS
ALTER TABLE public.polls ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.poll_options ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.poll_votes ENABLE ROW LEVEL SECURITY;

-- 5. Grant permissions
GRANT ALL ON TABLE public.polls TO authenticated;
GRANT ALL ON TABLE public.poll_options TO authenticated;
GRANT ALL ON TABLE public.poll_votes TO authenticated;

-- 6. RLS Policies — Polls
DROP POLICY IF EXISTS "Room members can read polls" ON public.polls;
CREATE POLICY "Room members can read polls"
  ON public.polls FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.room_members
      WHERE room_members.room_id = polls.room_id
        AND room_members.user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "Room members can create polls" ON public.polls;
CREATE POLICY "Room members can create polls"
  ON public.polls FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = created_by
    AND EXISTS (
      SELECT 1 FROM public.room_members
      WHERE room_members.room_id = polls.room_id
        AND room_members.user_id = auth.uid()
    )
  );

-- 7. RLS Policies — Poll Options
DROP POLICY IF EXISTS "Anyone can read poll options" ON public.poll_options;
CREATE POLICY "Anyone can read poll options"
  ON public.poll_options FOR SELECT
  TO authenticated
  USING (true);

DROP POLICY IF EXISTS "Poll creators can add options" ON public.poll_options;
CREATE POLICY "Poll creators can add options"
  ON public.poll_options FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() IS NOT NULL);

-- 8. RLS Policies — Poll Votes
DROP POLICY IF EXISTS "Anyone can read votes" ON public.poll_votes;
CREATE POLICY "Anyone can read votes"
  ON public.poll_votes FOR SELECT
  TO authenticated
  USING (true);

DROP POLICY IF EXISTS "Users can cast their own votes" ON public.poll_votes;
CREATE POLICY "Users can cast their own votes"
  ON public.poll_votes FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete their own votes" ON public.poll_votes;
CREATE POLICY "Users can delete their own votes"
  ON public.poll_votes FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- 9. Indexes
CREATE INDEX IF NOT EXISTS idx_polls_room_id ON public.polls(room_id);
CREATE INDEX IF NOT EXISTS idx_poll_options_poll_id ON public.poll_options(poll_id);
CREATE INDEX IF NOT EXISTS idx_poll_votes_poll_id ON public.poll_votes(poll_id);
CREATE INDEX IF NOT EXISTS idx_poll_votes_user_id ON public.poll_votes(user_id);
