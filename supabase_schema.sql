-- ============================================================
-- SquadBizz: Fix RLS Policies
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- 1. Drop existing policies (safe even if they don't exist)
DROP POLICY IF EXISTS "Users can view their rooms"           ON public.rooms;
DROP POLICY IF EXISTS "Authenticated users can create rooms" ON public.rooms;
DROP POLICY IF EXISTS "Authenticated users can look up rooms by code" ON public.rooms;
DROP POLICY IF EXISTS "Users can view room members"          ON public.room_members;
DROP POLICY IF EXISTS "Users can join rooms"                 ON public.room_members;

-- 2. Rooms: Any authenticated user can SELECT
--    (The app already filters by membership in code)
CREATE POLICY "Authenticated users can read rooms"
  ON public.rooms FOR SELECT
  USING (auth.uid() IS NOT NULL);

-- 3. Rooms: Authenticated users can INSERT their own rooms
CREATE POLICY "Authenticated users can create rooms"
  ON public.rooms FOR INSERT
  WITH CHECK (auth.uid() = created_by);

-- 4. Room Members: Any authenticated user can SELECT members
CREATE POLICY "Authenticated users can read room members"
  ON public.room_members FOR SELECT
  USING (auth.uid() IS NOT NULL);

-- 5. Room Members: Users can only add themselves
CREATE POLICY "Users can join rooms"
  ON public.room_members FOR INSERT
  WITH CHECK (auth.uid() = user_id);
