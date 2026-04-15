-- ============================================================
-- SquadBizz: Chat Messages Schema
-- Run in: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- 1. Chat Messages table
CREATE TABLE IF NOT EXISTS public.chat_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id UUID NOT NULL REFERENCES public.rooms(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  sender_name TEXT NOT NULL DEFAULT '',
  message TEXT NOT NULL,
  message_type TEXT NOT NULL DEFAULT 'text',  -- text, image, system
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Index for fast room message lookups
CREATE INDEX IF NOT EXISTS idx_chat_messages_room_id ON public.chat_messages(room_id);
CREATE INDEX IF NOT EXISTS idx_chat_messages_created_at ON public.chat_messages(created_at DESC);

-- 3. Enable RLS
ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY;

-- 4. Grant permissions
GRANT ALL ON TABLE public.chat_messages TO authenticated;

-- 5. Policies
DROP POLICY IF EXISTS "Room members can read messages" ON public.chat_messages;
CREATE POLICY "Room members can read messages"
  ON public.chat_messages FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.room_members
      WHERE room_members.room_id = chat_messages.room_id
        AND room_members.user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "Room members can send messages" ON public.chat_messages;
CREATE POLICY "Room members can send messages"
  ON public.chat_messages FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = sender_id
    AND EXISTS (
      SELECT 1 FROM public.room_members
      WHERE room_members.room_id = chat_messages.room_id
        AND room_members.user_id = auth.uid()
    )
  );

-- 6. Enable Realtime for chat_messages
ALTER PUBLICATION supabase_realtime ADD TABLE public.chat_messages;
