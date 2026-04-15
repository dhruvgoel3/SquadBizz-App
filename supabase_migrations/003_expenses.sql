-- ============================================================
-- SquadBizz: Expenses Schema
-- Run in: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- 1. Expenses table
CREATE TABLE IF NOT EXISTS public.expenses (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  room_id     UUID NOT NULL REFERENCES public.rooms(id) ON DELETE CASCADE,
  created_by  UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title       TEXT NOT NULL,
  amount      NUMERIC(12, 2) NOT NULL,
  currency    TEXT NOT NULL DEFAULT 'INR',
  split_type  TEXT NOT NULL DEFAULT 'equal',   -- 'equal', 'custom', 'percentage'
  note        TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Expense participants table
CREATE TABLE IF NOT EXISTS public.expense_participants (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  expense_id    UUID NOT NULL REFERENCES public.expenses(id) ON DELETE CASCADE,
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  amount_owed   NUMERIC(12, 2) NOT NULL DEFAULT 0,
  is_paid       BOOLEAN NOT NULL DEFAULT false,
  UNIQUE(expense_id, user_id)
);

-- 3. Grants and Enable RLS
GRANT ALL ON TABLE public.expenses TO authenticated;
GRANT ALL ON TABLE public.expense_participants TO authenticated;

ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expense_participants ENABLE ROW LEVEL SECURITY;

-- 4. RLS Policies — Expenses
DROP POLICY IF EXISTS "Authenticated users can read expenses" ON public.expenses;
CREATE POLICY "Authenticated users can read expenses"
  ON public.expenses FOR SELECT USING (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "Authenticated users can create expenses" ON public.expenses;
CREATE POLICY "Authenticated users can create expenses"
  ON public.expenses FOR INSERT WITH CHECK (auth.uid() = created_by);

-- 5. RLS Policies — Expense Participants
DROP POLICY IF EXISTS "Authenticated users can read expense participants" ON public.expense_participants;
CREATE POLICY "Authenticated users can read expense participants"
  ON public.expense_participants FOR SELECT USING (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "Expense creators can add participants" ON public.expense_participants;
CREATE POLICY "Expense creators can add participants"
  ON public.expense_participants FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "Participants can update their payment status" ON public.expense_participants;
CREATE POLICY "Participants can update their payment status"
  ON public.expense_participants FOR UPDATE USING (auth.uid() = user_id);

-- 6. Indexes (IF NOT EXISTS)
CREATE INDEX IF NOT EXISTS idx_expenses_room_id ON public.expenses(room_id);
CREATE INDEX IF NOT EXISTS idx_expenses_created_by ON public.expenses(created_by);
CREATE INDEX IF NOT EXISTS idx_expense_participants_expense_id ON public.expense_participants(expense_id);
CREATE INDEX IF NOT EXISTS idx_expense_participants_user_id ON public.expense_participants(user_id);

