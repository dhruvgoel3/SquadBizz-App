-- ============================================================
-- SquadBizz: Polls Schema
-- Run in: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- 1. Polls table
CREATE TABLE public.polls (
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
CREATE TABLE public.poll_options (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  poll_id     UUID NOT NULL REFERENCES public.polls(id) ON DELETE CASCADE,
  text        TEXT NOT NULL,
  sort_order  INT NOT NULL DEFAULT 0
);

-- 3. Poll votes table
CREATE TABLE public.poll_votes (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  poll_id         UUID NOT NULL REFERENCES public.polls(id) ON DELETE CASCADE,
  poll_option_id  UUID NOT NULL REFERENCES public.poll_options(id) ON DELETE CASCADE,
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(poll_id, poll_option_id, user_id)  -- one vote per option per user
);

-- 4. Enable RLS
ALTER TABLE public.polls ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.poll_options ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.poll_votes ENABLE ROW LEVEL SECURITY;

-- 5. RLS Policies — Polls
CREATE POLICY "Authenticated users can read polls"
  ON public.polls FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Authenticated users can create polls"
  ON public.polls FOR INSERT WITH CHECK (auth.uid() = created_by);

-- 6. RLS Policies — Poll Options
CREATE POLICY "Authenticated users can read poll options"
  ON public.poll_options FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Poll creators can add options"
  ON public.poll_options FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

-- 7. RLS Policies — Poll Votes
CREATE POLICY "Authenticated users can read votes"
  ON public.poll_votes FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Users can cast their own votes"
  ON public.poll_votes FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own votes"
  ON public.poll_votes FOR DELETE USING (auth.uid() = user_id);

-- 8. Indexes
CREATE INDEX idx_polls_room_id ON public.polls(room_id);
CREATE INDEX idx_poll_options_poll_id ON public.poll_options(poll_id);
CREATE INDEX idx_poll_votes_poll_id ON public.poll_votes(poll_id);
CREATE INDEX idx_poll_votes_user_id ON public.poll_votes(user_id);
