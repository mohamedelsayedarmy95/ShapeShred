# ShapeShred

نظام بيئي متكامل للياقة البدنية يدمج بين التكنولوجيا المتقدمة واللمسة البشرية لتحويل حياة المستخدمين.

## 🎯 الرؤية

أن نكون المنصة الرائدة عالمياً في اللياقة البدنية الرقمية، حيث ندمج بين التكنولوجيا المتقدمة واللمسة البشرية لتحويل حياة ملايين الأشخاص حول العالم.

## 🚀 الميزات الرئيسية

### الوحدة 1: محرك التدريب والمتابعة
- مكتبة تمارين شاملة (500+ تمرين)
- تتبع ذكي بالذكاء الاصطناعي (Pose Estimation)
- عد تلقائي للتكرارات
- اكتشاف أخطاء الوضع
- تتبع التقدم الجسماني
- أرقام قياسية شخصية (PRs)

### الوحدة 2: المدرب الحي والاتصال اليومي
- مدرب بشري حقيقي معتمد
- تقارير يومية شاملة
- محادثة مشفرة مع المدرب
- مكالمات فيديو
- مراجعات أسبوعية
- تعديلات شخصية على الخطط

### الوحدة 3: التغذية الديناميكية والمكملات
- خطة تغذية مخصصة بالذكاء الاصطناعي
- ماسح باركود للطعام
- اقتراحات وصفات ذكية
- تتبع الماكروز التفصيلي
- جدولة المكملات الغذائية

### شات بوت الذكاء الاصطناعي
- إجابات على أسئلة التمارين
- دعم تحفيزي
- نصائح تغذوية
- دعم على مدار الساعة

## 🏗️ البنية المعمارية

### المايكروسيرفيسز
- **Auth Service:** المصادقة والتفويض
- **User Service:** إدارة بيانات المستخدمين
- **Workout Service:** إدارة التمارين وخطط التدريب
- **Nutrition Service:** إدارة التغذية والمكملات
- **Coach Service:** إدارة المدربين وعلاقتهم بالمستخدمين
- **AI Service:** جميع وظائف الذكاء الاصطناعي
- **Notification Service:** إدارة الإشعارات
- **Payment Service:** إدارة المدفوعات والاشتراكات
- **Analytics Service:** تحليل البيانات والتقارير

### التقنيات المستخدمة

**Frontend:**
- Flutter (Mobile - Dart)
- React (Coach Web - TypeScript)
- BLoC (State Management)
- Flutter ScreenUtil

**Backend:**
- Node.js + TypeScript
- NestJS
- PostgreSQL
- Redis
- Socket.io

**AI/ML:**
- MediaPipe Pose
- OpenAI GPT-4
- TensorFlow Lite
- Custom ML Models

**DevOps:**
- Docker + Kubernetes
- AWS
- GitHub Actions
- Prometheus + Grafana

## 📁 هيكل المشروع

```
ShapeShred/
├── backend/
│   ├── auth-service/
│   ├── user-service/
│   ├── workout-service/
│   ├── nutrition-service/
│   ├── coach-service/
│   ├── ai-service/
│   ├── notification-service/
│   ├── payment-service/
│   ├── analytics-service/
│   └── shared/
├── frontend/
│   ├── mobile-app/
│   └── coach-web/
├── database/
│   ├── migrations/
│   └── seeds/
├── docs/
│   ├── api/
│   ├── architecture/
│   └── design/
├── devops/
│   ├── docker/
│   ├── kubernetes/
│   └── ci-cd/
└── infrastructure/
    ├── terraform/
    └── ansible/
```

## 🎨 نظام التصميم

**الثيم:** أسود وأبيض فقط (Strictly Monochrome)

**الألوان:**
- أسود خالص: #000000
- أبيض نقي: #FFFFFF
- رمادي داكن: #1A1A1A
- رمادي متوسط: #4A4A4A
- رمادي فاتح: #E0E0E0
- رمادي شاحب: #F5F5F5

**الخطوط:**
- SF Pro Display / Inter (العناوين)
- SF Pro Text / Inter (النصوص)
- SF Mono / JetBrains Mono (الأرقام)

## 💰 نموذج العمل

### الطبقة المجانية (Free Tier)
- مكتبة تمارين أساسية (100+ تمرين)
- خطط تدريب مولدة بالذكاء الاصطناعي
- تتبع التمارين الأساسي
- شات بوت محدود (10 رسائل/يوم)

### الطبقة المميزة (Premium Tier)
**الشهري:** $19.99/شهر
- مدرب بشري حقيقي
- خطة تغذية مخصصة
- تتبع AI pose estimation
- شات بوت غير محدود

**الربع سنوي:** $47.99/3 أشهر (خصم 20%)
- كل مميزات الشهري
- مكالمة فيديو إضافية

**السنوي:** $143.99/سنة (خصم 40%)
- كل مميزات الربع سنوي
- مكالمات فيديو غير محدودة
- مدرب مخصص طوال السنة

## 🔒 الأمان والامتثال

- تشفير AES-256 للبيانات
- TLS 1.3 للاتصالات
- OAuth 2.0 + MFA
- GDPR Compliance
- CCPA Compliance
- HIPAA Compliance
- SOC 2 Compliance

## 🚀 البدء

### المتطلبات
- Node.js 18+
- Flutter 3.10+
- Dart 3.0+
- PostgreSQL 14+
- Redis 7+
- Docker & Docker Compose

### التثبيت

```bash
# استنساخ المشروع
git clone https://github.com/your-org/shapeshred.git
cd shapeshred

# تثبيت اعتماديات الخلفية
cd backend
npm install

# تثبيت اعتماديات التطبيق المحمول
cd ../frontend/mobile-app/shapeshred
flutter pub get
```

### تشغيل التطبيق

```bash
# تشغيل جميع المايكروسيرفيسز
cd backend
npm run dev

# تشغيل التطبيق المحمول
cd ../frontend/mobile-app/shapeshred
flutter run
```

## 📖 خريطة الطريق

### المرحلة 1: MVP (6-9 أشهر)
- مكتبة تمارين أساسية
- تتبع يدوي
- مدرب بشري أساسي
- خطة تغذية مولدة

### المرحلة 2: التوسع (9-18 شهر)
- تتبع AI pose estimation
- ماسح باركود
- اقتراحات وصفات ذكية
- تحسينات المدرب

### المرحلة 3: الميزات المتقدمة (18-36 شهر)
- تكامل الساعات الذكية
- الواقع المعزز (AR)
- الميزات الاجتماعية
- Gamification

### المرحلة 4: النظام البيئي الكامل (36+ شهر)
- Marketplace للمدربين
- شراكات مع شركات اللياقة
- Corporate Wellness Programs

## 👥 الفريق

- **Product Manager:** [الاسم]
- **Lead Developer:** [الاسم]
- **UI/UX Designer:** [الاسم]
- **AI Engineer:** [الاسم]
- **DevOps Engineer:** [الاسم]

## 📄 الترخيص

جميع الحقوق محفوظة © 2025 ShapeShred

## 📞 التواصل

- البريد الإلكتروني: contact@shapeshred.com
- الموقع: https://shapeshred.com
- Twitter: @ShapeShredApp
