export type UserRole = 'parent' | 'teacher' | 'student' | 'admin'
export type LessonStatus = 'not_started' | 'in_progress' | 'completed' | 'needs_review'
export type SubscriptionPlan = 'trial' | 'monthly' | 'annual' | 'family' | 'teacher' | 'school_monthly' | 'school_annual'
export type SubscriptionStatus = 'active' | 'cancelled' | 'past_due' | 'trial' | 'expired'
export type VisibilityType = 'public' | 'class_only' | 'private'
export type ConsentType = 'weekly_digest' | 'product_updates' | 'promotions' | 'school_newsletter'
export type ConsentMethod = 'signup_form' | 'settings_update'
export type WithdrawMethod = 'unsubscribe_link' | 'settings' | 'admin_request'

export interface Database {
  public: {
    Tables: {
      users: {
        Row: {
          id: string
          email: string
          full_name: string | null
          role: UserRole
          locale: string
          avatar_url: string | null
          created_at: string
          updated_at: string
          deleted_at: string | null
        }
        Insert: {
          id: string
          email: string
          full_name?: string | null
          role?: UserRole
          locale?: string
          avatar_url?: string | null
          created_at?: string
          updated_at?: string
          deleted_at?: string | null
        }
        Update: {
          full_name?: string | null
          role?: UserRole
          locale?: string
          avatar_url?: string | null
          updated_at?: string
          deleted_at?: string | null
        }
      }
      parent_profiles: {
        Row: {
          id: string
          user_id: string
          notification_prefs: Record<string, boolean> | null
          timezone: string | null
          phone: string | null
          created_at: string
        }
        Insert: {
          id?: string
          user_id: string
          notification_prefs?: Record<string, boolean> | null
          timezone?: string | null
          phone?: string | null
        }
        Update: {
          notification_prefs?: Record<string, boolean> | null
          timezone?: string | null
          phone?: string | null
        }
      }
      teacher_profiles: {
        Row: {
          id: string
          user_id: string
          school_name: string | null
          classroom_name: string | null
          grade_range: string | null
          certification: string | null
          created_at: string
        }
        Insert: {
          id?: string
          user_id: string
          school_name?: string | null
          classroom_name?: string | null
          grade_range?: string | null
          certification?: string | null
        }
        Update: {
          school_name?: string | null
          classroom_name?: string | null
          grade_range?: string | null
          certification?: string | null
        }
      }
      student_profiles: {
        Row: {
          id: string
          parent_id: string
          teacher_id: string | null
          full_name: string
          age: number
          grade: string
          level: string
          xp_points: number
          streak_days: number
          xp_multiplier: number
          visibility: VisibilityType
          avatar_emoji: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          parent_id: string
          teacher_id?: string | null
          full_name: string
          age: number
          grade: string
          level?: string
          xp_points?: number
          streak_days?: number
          xp_multiplier?: number
          visibility?: VisibilityType
          avatar_emoji?: string | null
        }
        Update: {
          full_name?: string
          age?: number
          grade?: string
          level?: string
          xp_points?: number
          streak_days?: number
          xp_multiplier?: number
          visibility?: VisibilityType
          avatar_emoji?: string | null
          updated_at?: string
        }
      }
      lessons: {
        Row: {
          id: string
          slug: string
          title: string
          level: string
          category: string
          language: string
          difficulty: string | null
          duration_minutes: number
          instructions: string | null
          xp_reward: number
          is_visible: boolean
          sort_order: number | null
          created_at: string
        }
        Insert: {
          id?: string
          slug: string
          title: string
          level: string
          category: string
          language?: string
          difficulty?: string | null
          duration_minutes?: number
          instructions?: string | null
          xp_reward?: number
          is_visible?: boolean
          sort_order?: number | null
        }
        Update: {
          title?: string
          category?: string
          difficulty?: string | null
          duration_minutes?: number
          instructions?: string | null
          xp_reward?: number
          is_visible?: boolean
          sort_order?: number | null
        }
      }
      projects: {
        Row: {
          id: string
          slug: string
          title: string
          level: string
          category: string
          starter_code: string | null
          instructions: string | null
          tags: string[] | null
          xp_reward: number
          is_visible: boolean
          sort_order: number | null
          created_at: string
        }
        Insert: {
          id?: string
          slug: string
          title: string
          level: string
          category: string
          starter_code?: string | null
          instructions?: string | null
          tags?: string[] | null
          xp_reward?: number
          is_visible?: boolean
          sort_order?: number | null
        }
        Update: {
          title?: string
          category?: string
          starter_code?: string | null
          instructions?: string | null
          tags?: string[] | null
          xp_reward?: number
          is_visible?: boolean
          sort_order?: number | null
        }
      }
      quizzes: {
        Row: {
          id: string
          slug: string
          title: string
          level: string
          category: string
          time_limit_seconds: number
          passing_score: number
          xp_reward: number
          is_visible: boolean
          created_at: string
        }
        Insert: {
          id?: string
          slug: string
          title: string
          level: string
          category: string
          time_limit_seconds?: number
          passing_score?: number
          xp_reward?: number
          is_visible?: boolean
        }
        Update: {
          title?: string
          category?: string
          time_limit_seconds?: number
          passing_score?: number
          xp_reward?: number
          is_visible?: boolean
        }
      }
      quiz_questions: {
        Row: {
          id: string
          quiz_id: string
          question: string
          options: string[]
          correct_answer: number
          explanation: string | null
          points: number
          sort_order: number | null
        }
        Insert: {
          id?: string
          quiz_id: string
          question: string
          options: string[]
          correct_answer: number
          explanation?: string | null
          points?: number
          sort_order?: number | null
        }
        Update: {
          question?: string
          options?: string[]
          correct_answer?: number
          explanation?: string | null
          points?: number
          sort_order?: number | null
        }
      }
      lesson_progress: {
        Row: {
          id: string
          student_id: string
          lesson_id: string
          status: LessonStatus
          score: number | null
          hearts_remaining: number
          completed_at: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          student_id: string
          lesson_id: string
          status?: LessonStatus
          score?: number | null
          hearts_remaining?: number
          completed_at?: string | null
        }
        Update: {
          status?: LessonStatus
          score?: number | null
          hearts_remaining?: number
          completed_at?: string | null
          updated_at?: string
        }
      }
      quiz_attempts: {
        Row: {
          id: string
          student_id: string
          quiz_id: string
          score: number
          answers: Record<string, number>
          passed: boolean
          completed_at: string
          created_at: string
        }
        Insert: {
          id?: string
          student_id: string
          quiz_id: string
          score: number
          answers: Record<string, number>
          passed: boolean
          completed_at?: string
        }
        Update: {
          score?: number
          answers?: Record<string, number>
          passed?: boolean
        }
      }
      project_submissions: {
        Row: {
          id: string
          student_id: string
          project_id: string
          code_snapshot: string | null
          notes: string | null
          status: string
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          student_id: string
          project_id: string
          code_snapshot?: string | null
          notes?: string | null
          status?: string
        }
        Update: {
          code_snapshot?: string | null
          notes?: string | null
          status?: string
          updated_at?: string
        }
      }
      achievements: {
        Row: {
          id: string
          slug: string
          name: string
          description: string
          icon_emoji: string
          xp_reward: number
          condition_type: string
          is_active: boolean
        }
        Insert: {
          id?: string
          slug: string
          name: string
          description: string
          icon_emoji: string
          xp_reward?: number
          condition_type: string
          is_active?: boolean
        }
        Update: {
          name?: string
          description?: string
          icon_emoji?: string
          xp_reward?: number
          condition_type?: string
          is_active?: boolean
        }
      }
      student_achievements: {
        Row: {
          id: string
          student_id: string
          achievement_id: string
          awarded_at: string
        }
        Insert: {
          id?: string
          student_id: string
          achievement_id: string
          awarded_at?: string
        }
        Update: never
      }
      notifications: {
        Row: {
          id: string
          user_id: string
          type: string
          title: string
          message: string
          read: boolean
          created_at: string
        }
        Insert: {
          id?: string
          user_id: string
          type: string
          title: string
          message: string
          read?: boolean
        }
        Update: {
          read?: boolean
        }
      }
      subscriptions: {
        Row: {
          id: string
          user_id: string
          stripe_customer_id: string | null
          stripe_subscription_id: string | null
          plan: SubscriptionPlan
          status: SubscriptionStatus
          trial_ends_at: string | null
          current_period_end: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          stripe_customer_id?: string | null
          stripe_subscription_id?: string | null
          plan?: SubscriptionPlan
          status?: SubscriptionStatus
          trial_ends_at?: string | null
          current_period_end?: string | null
        }
        Update: {
          stripe_customer_id?: string | null
          stripe_subscription_id?: string | null
          plan?: SubscriptionPlan
          status?: SubscriptionStatus
          trial_ends_at?: string | null
          current_period_end?: string | null
          updated_at?: string
        }
      }
      classes: {
        Row: {
          id: string
          teacher_id: string
          name: string
          code: string
          grade: string | null
          is_active: boolean
          created_at: string
        }
        Insert: {
          id?: string
          teacher_id: string
          name: string
          code: string
          grade?: string | null
          is_active?: boolean
        }
        Update: {
          name?: string
          grade?: string | null
          is_active?: boolean
        }
      }
      class_memberships: {
        Row: {
          id: string
          class_id: string
          student_id: string
          joined_at: string
        }
        Insert: {
          id?: string
          class_id: string
          student_id: string
          joined_at?: string
        }
        Update: never
      }
      class_invites: {
        Row: {
          id: string
          class_id: string
          token: string
          max_uses: number
          use_count: number
          expires_at: string | null
          created_at: string
        }
        Insert: {
          id?: string
          class_id: string
          token: string
          max_uses?: number
          use_count?: number
          expires_at?: string | null
        }
        Update: {
          max_uses?: number
          use_count?: number
          expires_at?: string | null
        }
      }
      schools: {
        Row: {
          id: string
          name: string
          board: string | null
          address: string | null
          contact_name: string | null
          contact_email: string | null
          contact_phone: string | null
          license_type: string | null
          license_count: number
          created_at: string
        }
        Insert: {
          id?: string
          name: string
          board?: string | null
          address?: string | null
          contact_name?: string | null
          contact_email?: string | null
          contact_phone?: string | null
          license_type?: string | null
          license_count?: number
        }
        Update: {
          name?: string
          board?: string | null
          address?: string | null
          contact_name?: string | null
          contact_email?: string | null
          contact_phone?: string | null
          license_type?: string | null
          license_count?: number
        }
      }
      school_sessions: {
        Row: {
          id: string
          school_id: string
          date: string
          start_time: string | null
          duration_minutes: number
          topic: string | null
          instructor: string | null
          student_count: number | null
          status: string
          notes: string | null
          created_at: string
        }
        Insert: {
          id?: string
          school_id: string
          date: string
          start_time?: string | null
          duration_minutes?: number
          topic?: string | null
          instructor?: string | null
          student_count?: number | null
          status?: string
          notes?: string | null
        }
        Update: {
          date?: string
          start_time?: string | null
          duration_minutes?: number
          topic?: string | null
          instructor?: string | null
          student_count?: number | null
          status?: string
          notes?: string | null
        }
      }
      session_attendance: {
        Row: {
          id: string
          session_id: string
          student_name: string
          grade: string | null
          engagement_score: number | null
          notes: string | null
        }
        Insert: {
          id?: string
          session_id: string
          student_name: string
          grade?: string | null
          engagement_score?: number | null
          notes?: string | null
        }
        Update: {
          engagement_score?: number | null
          notes?: string | null
        }
      }
      certificates: {
        Row: {
          id: string
          student_id: string
          level: string
          pdf_url: string | null
          share_token: string
          issued_at: string
        }
        Insert: {
          id?: string
          student_id: string
          level: string
          pdf_url?: string | null
          share_token: string
          issued_at?: string
        }
        Update: {
          pdf_url?: string | null
        }
      }
      share_tokens: {
        Row: {
          id: string
          token: string
          type: string
          target_id: string
          created_by: string | null
          expires_at: string | null
          created_at: string
        }
        Insert: {
          id?: string
          token: string
          type: string
          target_id: string
          created_by?: string | null
          expires_at?: string | null
        }
        Update: {
          expires_at?: string | null
        }
      }
      email_consents: {
        Row: {
          id: string
          user_id: string
          consent_type: ConsentType
          consent_given_at: string
          consent_method: ConsentMethod
          ip_address: string | null
          withdrawn_at: string | null
          withdrawn_method: WithdrawMethod | null
        }
        Insert: {
          id?: string
          user_id: string
          consent_type: ConsentType
          consent_given_at?: string
          consent_method: ConsentMethod
          ip_address?: string | null
          withdrawn_at?: string | null
          withdrawn_method?: WithdrawMethod | null
        }
        Update: {
          withdrawn_at?: string | null
          withdrawn_method?: WithdrawMethod | null
        }
      }
      parental_consents: {
        Row: {
          id: string
          parent_user_id: string
          student_name: string
          student_age: number
          consent_given_at: string
          consent_method: string
          ip_address: string | null
          user_agent: string | null
          privacy_policy_version: string | null
          data_retention_acknowledged: boolean
          ai_processing_acknowledged: boolean
          marketing_opt_in: boolean
        }
        Insert: {
          id?: string
          parent_user_id: string
          student_name: string
          student_age: number
          consent_given_at?: string
          consent_method?: string
          ip_address?: string | null
          user_agent?: string | null
          privacy_policy_version?: string | null
          data_retention_acknowledged?: boolean
          ai_processing_acknowledged?: boolean
          marketing_opt_in?: boolean
        }
        Update: {
          data_retention_acknowledged?: boolean
          ai_processing_acknowledged?: boolean
          marketing_opt_in?: boolean
        }
      }
      audit_logs: {
        Row: {
          id: string
          user_id: string | null
          action: string
          target_id: string | null
          target_type: string | null
          metadata: Record<string, unknown> | null
          ip_address: string | null
          user_agent: string | null
          created_at: string
        }
        Insert: {
          id?: string
          user_id?: string | null
          action: string
          target_id?: string | null
          target_type?: string | null
          metadata?: Record<string, unknown> | null
          ip_address?: string | null
          user_agent?: string | null
        }
        Update: never
      }
      learning_plans: {
        Row: {
          id: string
          student_id: string
          parent_id: string
          plan: Record<string, unknown>
          week_start: string | null
          created_at: string
        }
        Insert: {
          id?: string
          student_id: string
          parent_id: string
          plan: Record<string, unknown>
          week_start?: string | null
        }
        Update: {
          plan?: Record<string, unknown>
          week_start?: string | null
        }
      }
      assessments: {
        Row: {
          id: string
          parent_id: string
          student_name: string
          age: number
          grade: string
          experience: string
          skills: Record<string, number>
          recommended_level: string | null
          saved_at: string | null
          created_at: string
        }
        Insert: {
          id?: string
          parent_id: string
          student_name: string
          age: number
          grade: string
          experience: string
          skills: Record<string, number>
          recommended_level?: string | null
          saved_at?: string | null
        }
        Update: {
          recommended_level?: string | null
          saved_at?: string | null
        }
      }
      topic_mastery: {
        Row: {
          id: string
          student_id: string
          topic: string
          level: string
          mastery_score: number
          attempts: number
          updated_at: string
        }
        Insert: {
          id?: string
          student_id: string
          topic: string
          level: string
          mastery_score?: number
          attempts?: number
        }
        Update: {
          mastery_score?: number
          attempts?: number
          updated_at?: string
        }
      }
    }
    Views: Record<string, never>
    Functions: {
      award_xp: {
        Args: { p_student_id: string; p_base_xp: number }
        Returns: number
      }
      check_level_completion: {
        Args: { p_student_id: string }
        Returns: boolean
      }
      join_class_by_code: {
        Args: { p_code: string; p_student_id: string }
        Returns: boolean
      }
      join_class_by_token: {
        Args: { p_token: string; p_student_id: string }
        Returns: boolean
      }
    }
    Enums: {
      user_role: UserRole
      lesson_status: LessonStatus
      subscription_plan: SubscriptionPlan
      subscription_status: SubscriptionStatus
      visibility_type: VisibilityType
      consent_type: ConsentType
      consent_method: ConsentMethod
      withdraw_method: WithdrawMethod
    }
  }
}
