-- FORNO ROSSO: initial Supabase schema
-- Run this in Supabase SQL Editor. Keep the service_role key off the website.

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.orders (
  id text primary key,
  customer_name text not null,
  phone text not null,
  fulfillment text not null check (fulfillment in ('delivery','pickup')),
  address text not null default '',
  items jsonb not null,
  total numeric(10,2) not null check (total >= 0),
  status text not null default 'Nuevo' check (status in ('Nuevo','En preparación','Listo','Completado','Cancelado')),
  created_at timestamptz not null default now()
);

create table if not exists public.reservations (
  id text primary key,
  name text not null,
  reservation_date date not null,
  reservation_time text not null,
  guests text not null,
  phone text not null,
  created_at timestamptz not null default now()
);

alter table public.admin_users enable row level security;
alter table public.orders enable row level security;
alter table public.reservations enable row level security;

create policy "admins can view their own access row"
  on public.admin_users for select to authenticated using (user_id = (select auth.uid()));

create policy "customers can submit orders"
  on public.orders for insert to anon, authenticated with check (
    status = 'Nuevo' and total >= 0 and length(customer_name) > 0 and length(phone) > 0
  );
create policy "admins can read orders"
  on public.orders for select to authenticated using (
    exists (select 1 from public.admin_users where user_id = (select auth.uid()))
  );
create policy "admins can update orders"
  on public.orders for update to authenticated using (
    exists (select 1 from public.admin_users where user_id = (select auth.uid()))
  ) with check (
    exists (select 1 from public.admin_users where user_id = (select auth.uid()))
  );

create policy "customers can submit reservations"
  on public.reservations for insert to anon, authenticated with check (
    length(name) > 0 and length(phone) > 0
  );
create policy "admins can read reservations"
  on public.reservations for select to authenticated using (
    exists (select 1 from public.admin_users where user_id = (select auth.uid()))
  );

grant usage on schema public to anon, authenticated;
grant insert on public.orders, public.reservations to anon, authenticated;
grant select on public.orders, public.reservations, public.admin_users to authenticated;
grant update (status) on public.orders to authenticated;

-- Create each administrator in Authentication first, then authorize their UUID:
-- insert into public.admin_users (user_id) values ('AUTH_USER_UUID');
