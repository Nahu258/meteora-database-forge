
-- RLS POLICIES
CREATE POLICY "Admins can manage banners" ON public.banners FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Authenticated users can view active banners" ON public.banners FOR SELECT USING ((auth.uid() IS NOT NULL) AND (active = true));

CREATE POLICY "Admins can manage comments" ON public.community_comments FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Authenticated users can view comments" ON public.community_comments FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY "Users can create comments" ON public.community_comments FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own comments" ON public.community_comments FOR DELETE USING (auth.uid() = user_id);
CREATE POLICY "Users can update own comments" ON public.community_comments FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Admins can manage likes" ON public.community_likes FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Authenticated users can view likes" ON public.community_likes FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY "Users can create likes" ON public.community_likes FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own likes" ON public.community_likes FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY "Admins can manage posts" ON public.community_posts FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Authenticated users can view posts" ON public.community_posts FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY "Users can create posts" ON public.community_posts FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own posts" ON public.community_posts FOR DELETE USING (auth.uid() = user_id);
CREATE POLICY "Users can update own posts" ON public.community_posts FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Admins can manage categories" ON public.course_categories FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Authenticated users can view categories" ON public.course_categories FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Admins can manage enrollments" ON public.course_enrollments FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can view own enrollments" ON public.course_enrollments FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Admins can manage lessons" ON public.course_lessons FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can view lessons" ON public.course_lessons FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Admins can manage modules" ON public.course_modules FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can view modules of published courses" ON public.course_modules FOR SELECT USING ((auth.uid() IS NOT NULL) AND (EXISTS (SELECT 1 FROM courses WHERE courses.id = course_modules.course_id AND courses.status = 'published')));

CREATE POLICY "Admins can manage courses" ON public.courses FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can view published courses" ON public.courses FOR SELECT USING ((auth.uid() IS NOT NULL) AND (status = 'published'));

CREATE POLICY "Admins can view all diagnostic answers" ON public.diagnostic_answers FOR SELECT USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Anyone can insert diagnostic answers" ON public.diagnostic_answers FOR INSERT WITH CHECK (true);

CREATE POLICY "Admins can manage lead tracking" ON public.diagnostic_lead_tracking FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Anyone can insert lead tracking" ON public.diagnostic_lead_tracking FOR INSERT TO anon, authenticated WITH CHECK (true);

CREATE POLICY "Admins can manage diagnostic questions" ON public.diagnostic_questions FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Anyone can view diagnostic questions" ON public.diagnostic_questions FOR SELECT USING (true);

CREATE POLICY "Admins can manage diagnostic rules" ON public.diagnostic_recommendation_rules FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Anyone can view diagnostic rules" ON public.diagnostic_recommendation_rules FOR SELECT USING (true);

CREATE POLICY "Admins can delete diagnostics" ON public.diagnostics FOR DELETE USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Admins can update diagnostics" ON public.diagnostics FOR UPDATE USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Admins can view diagnostics" ON public.diagnostics FOR SELECT USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Anyone can insert diagnostics" ON public.diagnostics FOR INSERT TO anon, authenticated WITH CHECK (true);
CREATE POLICY "Anyone can select diagnostics by email" ON public.diagnostics FOR SELECT TO anon USING (true);

CREATE POLICY "Admins can manage lesson_comments" ON public.lesson_comments FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can create lesson_comments" ON public.lesson_comments FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own lesson_comments" ON public.lesson_comments FOR DELETE USING (auth.uid() = user_id);
CREATE POLICY "Users can update own lesson_comments" ON public.lesson_comments FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can view lesson_comments" ON public.lesson_comments FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Admins can manage lesson_contents" ON public.lesson_contents FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can view lesson_contents" ON public.lesson_contents FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Admins can manage progress" ON public.lesson_progress FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can insert own progress" ON public.lesson_progress FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own progress" ON public.lesson_progress FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can view own progress" ON public.lesson_progress FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Admins can manage ratings" ON public.lesson_ratings FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can create own ratings" ON public.lesson_ratings FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own ratings" ON public.lesson_ratings FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can view ratings" ON public.lesson_ratings FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Admins manage menu_link_packages" ON public.menu_link_packages FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Anyone can read menu_link_packages" ON public.menu_link_packages FOR SELECT USING (true);

CREATE POLICY "Admins manage menu_link_products" ON public.menu_link_products FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Anyone can read menu_link_products" ON public.menu_link_products FOR SELECT USING (true);

CREATE POLICY "Admins manage menu_links" ON public.menu_links FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Anyone can read menu_links" ON public.menu_links FOR SELECT USING (true);

CREATE POLICY "Users can create own topologies" ON public.network_topologies FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own topologies" ON public.network_topologies FOR DELETE USING (auth.uid() = user_id);
CREATE POLICY "Users can update own topologies" ON public.network_topologies FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can view own topologies" ON public.network_topologies FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Admins can manage offers" ON public.offers FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can view active offers" ON public.offers FOR SELECT USING ((auth.uid() IS NOT NULL) AND (active = true));

CREATE POLICY "Admins can manage package_product_groups" ON public.package_product_groups FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can view package_product_groups" ON public.package_product_groups FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Admins can manage package_products" ON public.package_products FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can view package_products" ON public.package_products FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Admins can manage packages" ON public.packages FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can view active packages" ON public.packages FOR SELECT USING ((auth.uid() IS NOT NULL) AND (active = true));

CREATE POLICY "Admins can manage plan_courses" ON public.plan_courses FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can view plan_courses" ON public.plan_courses FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Admins can manage plan_meetings" ON public.plan_meetings FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can view meetings for their plans" ON public.plan_meetings FOR SELECT USING (EXISTS (SELECT 1 FROM user_plans up WHERE up.user_id = auth.uid() AND up.package_id = plan_meetings.package_id AND up.status = 'active'));

CREATE POLICY "Admins can manage plan_services" ON public.plan_services FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can view plan_services" ON public.plan_services FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Admins can manage plans" ON public.plans FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Authenticated users can view active plans" ON public.plans FOR SELECT USING ((auth.uid() IS NOT NULL) AND (active = true));

CREATE POLICY "Admins can manage platform_settings" ON public.platform_settings FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));

CREATE POLICY "Admins can manage product_categories" ON public.product_categories FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can view product_categories" ON public.product_categories FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Admins can manage product_sales_pages" ON public.product_sales_pages FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Anyone can view active sales pages" ON public.product_sales_pages FOR SELECT USING (active = true);

CREATE POLICY "Admins can manage products" ON public.products FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can view active products" ON public.products FOR SELECT USING ((auth.uid() IS NOT NULL) AND (active = true));

CREATE POLICY "Admins can delete any profile" ON public.profiles FOR DELETE USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Admins can update all profiles" ON public.profiles FOR UPDATE USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Admins can view all profiles" ON public.profiles FOR SELECT USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can delete own profile" ON public.profiles FOR DELETE USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own profile" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can view own profile" ON public.profiles FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Admins can manage services" ON public.services FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Authenticated users can view active services" ON public.services FOR SELECT USING ((auth.uid() IS NOT NULL) AND (active = true));

CREATE POLICY "Admins can insert system logs" ON public.system_logs FOR INSERT WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Admins can view system_logs" ON public.system_logs FOR SELECT USING (has_role(auth.uid(), 'admin'::app_role));

CREATE POLICY "Admins can manage testimonials" ON public.testimonials FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Anyone can view active testimonials" ON public.testimonials FOR SELECT USING (active = true);

CREATE POLICY "Admins can manage user_lesson_access" ON public.user_lesson_access FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can view own lesson_access" ON public.user_lesson_access FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Admins can manage user_plans" ON public.user_plans FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can view own plans" ON public.user_plans FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Admins can manage user_products" ON public.user_products FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can view own products" ON public.user_products FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Admins can manage user_roles" ON public.user_roles FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can view own roles" ON public.user_roles FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Admins can manage webhook_endpoints" ON public.webhook_endpoints FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));

CREATE POLICY "Admins can manage webhook_event_types" ON public.webhook_event_types FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Anyone can view webhook_event_types" ON public.webhook_event_types FOR SELECT USING (true);

-- TRIGGER: handle_new_user on auth.users
CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
