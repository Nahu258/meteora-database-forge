
-- 1. ENUMS
CREATE TYPE public.app_role AS ENUM ('admin', 'moderator', 'user');
CREATE TYPE public.lesson_content_type AS ENUM ('video', 'text', 'image', 'audio', 'link', 'pdf');
CREATE TYPE public.product_type AS ENUM ('course', 'service', 'consultation', 'implementation', 'virtual_event', 'in_person_event', 'saas');

-- 2. TABLES (no FK dependencies first)
CREATE TABLE public.course_categories (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name text NOT NULL,
  description text,
  created_at timestamptz NOT NULL DEFAULT now(),
  auto_translate boolean NOT NULL DEFAULT true
);

CREATE TABLE public.courses (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  title text NOT NULL,
  description text,
  category_id uuid,
  thumbnail_url text,
  thumbnail_vertical_url text,
  status text NOT NULL DEFAULT 'draft'::text,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT courses_status_check CHECK (status = ANY (ARRAY['draft'::text, 'published'::text]))
);

CREATE TABLE public.course_modules (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  course_id uuid NOT NULL,
  title text NOT NULL,
  description text,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.course_lessons (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  module_id uuid NOT NULL,
  title text NOT NULL,
  description text,
  video_url text,
  duration_minutes integer DEFAULT 0,
  sort_order integer NOT NULL DEFAULT 0,
  is_free boolean NOT NULL DEFAULT false,
  is_private boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.course_enrollments (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  course_id uuid NOT NULL,
  user_id uuid NOT NULL,
  enrolled_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT course_enrollments_course_id_user_id_key UNIQUE (course_id, user_id)
);

CREATE TABLE public.community_posts (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  course_id uuid NOT NULL,
  user_id uuid NOT NULL,
  title text NOT NULL,
  content text NOT NULL,
  image_url text,
  link_url text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.community_comments (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  post_id uuid NOT NULL,
  user_id uuid NOT NULL,
  parent_id uuid,
  content text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.community_likes (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  post_id uuid NOT NULL,
  user_id uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT community_likes_post_id_user_id_key UNIQUE (post_id, user_id)
);

CREATE TABLE public.diagnostics (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name text NOT NULL,
  email text NOT NULL,
  phone text,
  country text,
  company_name text,
  role_type text,
  client_count text,
  network_type text,
  cheapest_plan numeric,
  main_problems text,
  main_goals text,
  tech_knowledge text,
  status text DEFAULT 'pending'::text,
  user_id uuid,
  scores jsonb DEFAULT '{}'::jsonb,
  results jsonb DEFAULT '{}'::jsonb,
  archived boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.diagnostic_questions (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  section text NOT NULL,
  type text NOT NULL,
  question_text text NOT NULL,
  description text,
  options jsonb DEFAULT '[]'::jsonb,
  weight numeric DEFAULT 1.0,
  sort_order integer DEFAULT 0,
  field_key text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE public.diagnostic_answers (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  diagnostic_id uuid,
  question_id uuid,
  answer_value jsonb NOT NULL,
  score_contribution numeric DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE public.diagnostic_lead_tracking (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  diagnostic_id uuid NOT NULL,
  lead_temperature text NOT NULL DEFAULT 'cold'::text,
  commercial_status text NOT NULL DEFAULT 'new'::text,
  assigned_advisor text,
  recommended_product_auto text,
  assigned_level_auto text,
  last_action text,
  last_action_at timestamptz,
  notes text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT diagnostic_lead_tracking_diagnostic_id_key UNIQUE (diagnostic_id)
);

CREATE TABLE public.products (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name text NOT NULL,
  description text,
  type public.product_type NOT NULL,
  active boolean NOT NULL DEFAULT true,
  payment_type text NOT NULL DEFAULT 'one_time'::text,
  recurring_type text,
  course_id uuid,
  saas_url text,
  show_on_home boolean NOT NULL DEFAULT false,
  has_content boolean NOT NULL DEFAULT false,
  features_list jsonb DEFAULT '[]'::jsonb,
  thumbnail_url text,
  thumbnail_vertical_url text,
  cta_type text DEFAULT 'direct_purchase'::text,
  cta_url text,
  trial_enabled boolean NOT NULL DEFAULT false,
  trial_days integer,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.diagnostic_recommendation_rules (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  condition_field text NOT NULL,
  condition_operator text NOT NULL,
  condition_value numeric NOT NULL,
  recommended_product_id uuid,
  priority integer DEFAULT 0,
  title text,
  description text,
  cta_text text,
  cta_type text DEFAULT 'custom_url'::text,
  cta_url text,
  conditions jsonb DEFAULT '[]'::jsonb,
  conditions_logic text NOT NULL DEFAULT 'and'::text,
  recommended_product_ids uuid[] DEFAULT '{}'::uuid[],
  recommended_package_ids uuid[] DEFAULT '{}'::uuid[],
  created_at timestamptz DEFAULT now()
);

CREATE TABLE public.banners (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  title text NOT NULL DEFAULT ''::text,
  subtitle text,
  image_url text,
  video_url text,
  link_url text,
  link_label text DEFAULT 'Saiba Mais'::text,
  link_target text DEFAULT '_self'::text,
  active boolean NOT NULL DEFAULT true,
  sort_order integer NOT NULL DEFAULT 0,
  valid_from timestamptz,
  valid_until timestamptz,
  segment_exclude_product_id uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.lesson_comments (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  lesson_id uuid NOT NULL,
  course_id uuid NOT NULL,
  user_id uuid NOT NULL,
  content text NOT NULL,
  comment_type text NOT NULL DEFAULT 'comment'::text,
  video_timestamp_seconds integer,
  parent_id uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.lesson_contents (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  lesson_id uuid NOT NULL,
  type public.lesson_content_type NOT NULL,
  title text NOT NULL,
  content text,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.lesson_progress (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id uuid NOT NULL,
  course_id uuid NOT NULL,
  lesson_id uuid NOT NULL,
  completed boolean NOT NULL DEFAULT false,
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT lesson_progress_user_course_lesson_key UNIQUE (user_id, course_id, lesson_id)
);

CREATE TABLE public.lesson_ratings (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id uuid NOT NULL,
  lesson_id uuid NOT NULL,
  course_id uuid NOT NULL,
  rating integer NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT lesson_ratings_rating_check CHECK (rating >= 1 AND rating <= 5),
  CONSTRAINT lesson_ratings_user_id_lesson_id_key UNIQUE (user_id, lesson_id)
);

CREATE TABLE public.menu_links (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  title text NOT NULL,
  url text NOT NULL,
  icon text NOT NULL DEFAULT 'link'::text,
  open_mode text NOT NULL DEFAULT 'same_tab'::text,
  active boolean NOT NULL DEFAULT true,
  auto_translate boolean NOT NULL DEFAULT false,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.menu_link_products (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  menu_link_id uuid NOT NULL,
  product_id uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT menu_link_products_menu_link_id_product_id_key UNIQUE (menu_link_id, product_id)
);

CREATE TABLE public.menu_link_packages (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  menu_link_id uuid NOT NULL,
  package_id uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT menu_link_packages_menu_link_id_package_id_key UNIQUE (menu_link_id, package_id)
);

CREATE TABLE public.network_topologies (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id uuid NOT NULL,
  name text NOT NULL DEFAULT 'Minha Topologia'::text,
  data jsonb NOT NULL DEFAULT '{"edges": [], "nodes": []}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.product_categories (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  product_id uuid NOT NULL,
  category_id uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT product_categories_product_id_category_id_key UNIQUE (product_id, category_id)
);

CREATE TABLE public.product_sales_pages (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  product_id uuid NOT NULL,
  slug text NOT NULL,
  active boolean NOT NULL DEFAULT false,
  hero_headline text, hero_subheadline text, hero_context_line text,
  hero_cta_text text, hero_cta_link text, hero_background_image text,
  hero_badge_text text, hero_social_proof_micro text, hero_video_url text,
  problem_title text, problem_bullet_points jsonb DEFAULT '[]'::jsonb,
  problem_explanation_title text, problem_explanation_text text,
  transformation_title text, before_points jsonb DEFAULT '[]'::jsonb,
  after_points jsonb DEFAULT '[]'::jsonb,
  social_micro_number text, social_micro_text text, social_micro_badge text,
  core_benefits jsonb DEFAULT '[]'::jsonb, modules jsonb DEFAULT '[]'::jsonb,
  program_name text, program_format text, program_duration text, program_access_time text,
  selected_testimonials jsonb DEFAULT '[]'::jsonb, objections jsonb DEFAULT '[]'::jsonb,
  bonuses jsonb DEFAULT '[]'::jsonb, anchor_items jsonb DEFAULT '[]'::jsonb,
  anchor_total_value text, anchor_comparison_text text,
  price_display text, price_original text, price_installments text,
  price_currency text DEFAULT 'USD'::text, price_stripe_link text, price_highlight_text text,
  guarantee_title text, guarantee_description text, guarantee_type text, guarantee_days integer,
  urgency_type text, urgency_text text, urgency_date timestamptz, urgency_spots_remaining integer,
  countdown_enabled boolean DEFAULT false,
  final_cta_title text, final_cta_text text, final_cta_button_text text, final_cta_link text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT unique_product_sales_page UNIQUE (product_id),
  CONSTRAINT unique_slug UNIQUE (slug)
);

CREATE TABLE public.packages (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name text NOT NULL, description text,
  active boolean NOT NULL DEFAULT true,
  payment_type text NOT NULL DEFAULT 'one_time'::text,
  duration_days integer, is_trail boolean NOT NULL DEFAULT false,
  show_in_showcase boolean NOT NULL DEFAULT false,
  features text[] DEFAULT '{}'::text[],
  thumbnail_url text, thumbnail_vertical_url text,
  cta_type text DEFAULT 'direct_purchase'::text, cta_url text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.package_product_groups (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  package_id uuid NOT NULL, name text NOT NULL, description text,
  thumbnail_url text, thumbnail_vertical_url text,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.package_products (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  package_id uuid NOT NULL, product_id uuid NOT NULL, group_id uuid,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT package_products_package_id_product_id_key UNIQUE (package_id, product_id)
);

CREATE TABLE public.offers (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  product_id uuid, package_id uuid,
  name text NOT NULL DEFAULT 'Oferta Padrão'::text,
  price numeric NOT NULL DEFAULT 0, currency text NOT NULL DEFAULT 'USD'::text,
  duration_type text NOT NULL DEFAULT 'no_expiration'::text,
  duration_days integer, periodicity text,
  is_default boolean NOT NULL DEFAULT false, active boolean NOT NULL DEFAULT true,
  payment_link_active boolean NOT NULL DEFAULT true,
  stripe_link_active boolean NOT NULL DEFAULT false, stripe_price_id text,
  hotmart_link_active boolean NOT NULL DEFAULT false, hotmart_url text,
  valid_from timestamptz, valid_until timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT offers_one_parent CHECK (
    ((product_id IS NOT NULL) AND (package_id IS NULL)) OR
    ((product_id IS NULL) AND (package_id IS NOT NULL))
  )
);

CREATE TABLE public.plans (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name text NOT NULL, description text,
  price numeric NOT NULL DEFAULT 0, currency text NOT NULL DEFAULT 'USD'::text,
  payment_type text NOT NULL DEFAULT 'monthly'::text,
  duration_days integer, active boolean NOT NULL DEFAULT true,
  features text[] DEFAULT '{}'::text[],
  stripe_price_id text, stripe_product_id text,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT plans_payment_type_check CHECK (payment_type = ANY (ARRAY['one_time'::text, 'monthly'::text]))
);

CREATE TABLE public.plan_courses (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  plan_id uuid NOT NULL, course_id uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT plan_courses_plan_id_course_id_key UNIQUE (plan_id, course_id)
);

CREATE TABLE public.plan_meetings (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  package_id uuid NOT NULL, title text NOT NULL, description text,
  meeting_date timestamptz NOT NULL, meeting_link text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.plan_services (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  plan_id uuid NOT NULL, service_id uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT plan_services_plan_id_service_id_key UNIQUE (plan_id, service_id)
);

CREATE TABLE public.profiles (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id uuid NOT NULL, email text, display_name text, avatar_url text,
  bio text, phone text, cpf text, gender text, birth_date date,
  country text, company_name text, role_type text, client_count text,
  network_type text, cheapest_plan_usd numeric,
  main_problems text, main_desires text, observations text,
  status text NOT NULL DEFAULT 'pending'::text,
  approved boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT profiles_user_id_key UNIQUE (user_id),
  CONSTRAINT bio_length CHECK (length(bio) <= 500),
  CONSTRAINT company_name_length CHECK (length(company_name) <= 200),
  CONSTRAINT display_name_length CHECK (length(display_name) <= 100),
  CONSTRAINT main_desires_length CHECK (length(main_desires) <= 2000),
  CONSTRAINT main_problems_length CHECK (length(main_problems) <= 2000),
  CONSTRAINT phone_length CHECK (length(phone) <= 20),
  CONSTRAINT valid_network_type CHECK (network_type IS NULL OR network_type = ANY (ARRAY['radio'::text, 'fiber'::text, 'both'::text])),
  CONSTRAINT valid_role_type CHECK (role_type IS NULL OR role_type = ANY (ARRAY['owner'::text, 'employee'::text]))
);

CREATE TABLE public.services (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  title text NOT NULL, description text,
  price numeric NOT NULL DEFAULT 0, currency text NOT NULL DEFAULT 'USD'::text,
  payment_type text NOT NULL DEFAULT 'one_time'::text,
  active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT services_payment_type_check CHECK (payment_type = ANY (ARRAY['monthly'::text, 'one_time'::text]))
);

CREATE TABLE public.platform_settings (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  key text NOT NULL, value text,
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT platform_settings_key_key UNIQUE (key)
);

CREATE TABLE public.system_logs (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  action text NOT NULL, entity_type text NOT NULL DEFAULT 'system'::text,
  entity_id text, level text NOT NULL DEFAULT 'info'::text,
  details text, performed_by uuid, performer_email text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.testimonials (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  person_name text NOT NULL, title text, description text, role text,
  country text, isp_size text, result_text text, video_url text,
  tags text[], destinations text[], product_ids text[],
  active boolean NOT NULL DEFAULT true, sort_order integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.user_lesson_access (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id uuid NOT NULL, lesson_id uuid NOT NULL, granted_by uuid,
  granted_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT user_lesson_access_user_id_lesson_id_key UNIQUE (user_id, lesson_id)
);

CREATE TABLE public.user_plans (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id uuid NOT NULL, package_id uuid NOT NULL, offer_id uuid,
  status text NOT NULL DEFAULT 'active'::text,
  starts_at timestamptz NOT NULL DEFAULT now(), expires_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT user_plans_status_check CHECK (status = ANY (ARRAY['active'::text, 'cancelled'::text, 'expired'::text]))
);

CREATE TABLE public.user_products (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id uuid NOT NULL, product_id uuid NOT NULL, offer_id uuid,
  expires_at timestamptz, created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT user_products_user_id_product_id_key UNIQUE (user_id, product_id)
);

CREATE TABLE public.user_roles (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id uuid NOT NULL,
  role public.app_role NOT NULL,
  CONSTRAINT user_roles_user_id_role_key UNIQUE (user_id, role)
);

CREATE TABLE public.webhook_endpoints (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name text NOT NULL DEFAULT ''::text, url text NOT NULL,
  active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.webhook_event_types (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  event_key text NOT NULL, label text NOT NULL,
  enabled boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT webhook_event_types_event_key_key UNIQUE (event_key)
);

-- 3. FUNCTIONS (after tables exist)
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
 RETURNS trigger LANGUAGE plpgsql SET search_path TO 'public'
AS $function$ BEGIN NEW.updated_at = now(); RETURN NEW; END; $function$;

CREATE OR REPLACE FUNCTION public.check_email_exists(check_email text)
 RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path TO 'public'
AS $function$
  SELECT EXISTS (SELECT 1 FROM public.profiles WHERE LOWER(email) = LOWER(check_email))
$function$;

CREATE OR REPLACE FUNCTION public.has_role(_user_id uuid, _role app_role)
 RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path TO 'public'
AS $function$
  SELECT EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = _user_id AND role = _role)
$function$;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public'
AS $function$
BEGIN
  INSERT INTO public.profiles (
    user_id, email, display_name, role_type, company_name,
    country, phone, client_count, network_type, cheapest_plan_usd,
    main_problems, main_desires
  ) VALUES (
    NEW.id, NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'display_name', NEW.email),
    NEW.raw_user_meta_data->>'role_type',
    NEW.raw_user_meta_data->>'company_name',
    NEW.raw_user_meta_data->>'country',
    NEW.raw_user_meta_data->>'phone',
    NEW.raw_user_meta_data->>'client_count',
    NEW.raw_user_meta_data->>'network_type',
    NULLIF(NEW.raw_user_meta_data->>'cheapest_plan_usd', '')::numeric,
    NEW.raw_user_meta_data->>'main_problems',
    NEW.raw_user_meta_data->>'main_desires'
  );
  RETURN NEW;
END;
$function$;
