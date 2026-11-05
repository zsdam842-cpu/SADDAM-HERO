# SADDAM HERO — Saddam-Battle

لعبة أكشن عسكرية ثلاثية الأبعاد أصلية مبنية على Godot 4.3 وGDScript. المستودع يحتوي المشروع كاملًا من المصدر حتى بناء ملف APK جاهز للتثبيت.

## ما فيها الآن

- لاعب منظور ثالث: حركة، جري، قفز، انحناء، كاميرا فأرة.
- سلاح hitscan مع ذخيرة ومخزن وإعادة تلقيم.
- عدو يكتشف اللاعب ويطارده ويهاجمه.
- صحة ودرع وإعادة تشغيل المشهد عند نفاد الصحة.
- HUD يعرض الصحة والدرع والذخيرة وعدد الإقصاءات.
- بيانات حملة من 12 مهمة في `data/missions.json` (بنية بيانات أولية).
- أيقونة تطبيق واسم حزمة أندرويد `com.saddamhero.game`.

## التحكم

- WASD: الحركة
- Shift: الجري
- Space: القفز
- C: الانحناء
- الفأرة: توجيه الكاميرا
- زر الفأرة الأيسر: إطلاق النار
- R: إعادة التلقيم
- Esc: تحرير مؤشر الفأرة

## التشغيل من المصدر

1. نزّل Godot 4.3 أو أحدث.
2. افتح `project.godot`.
3. شغّل المشهد الرئيسي `scenes/main.tscn`.

## بناء APK

### عبر GitHub Actions (الطريقة الأسهل)

كل دفعة إلى `main` تشغّل `.github/workflows/android-build.yml`، وهي:

1. تثبّت Godot 4.3 وقوالب التصدير.
2. تثبّت حزم Android SDK المطلوبة.
3. تستورد المشروع وتجري فحص تشغيل headless.
4. تصدّر APK وتتحقق من توقيعه، ثم ترفعه كـ artifact باسم `SADDAM-HERO-android-debug`.

الملف يُنزّل من صفحة تشغيل الـ workflow في تبويب Actions.

### محليًا (Linux)

المتطلبات: JDK 17، Android SDK فيه `platform-tools` و`build-tools;34.0.0` و`platforms;android-34`، وقوالب تصدير Godot 4.3 في
`~/.local/share/godot/export_templates/4.3.stable/`.

```bash
# 1) مفتاح تصحيح
mkdir -p ~/.android
keytool -keyalg RSA -genkeypair -alias androiddebugkey -keypass android \
  -keystore ~/.android/debug.keystore -storepass android \
  -dname "CN=Android Debug,O=Android,C=US" -validity 9999 -deststoretype pkcs12

# 2) مسارات SDK وJDK في إعدادات محرر Godot
#    export/android/android_sdk_path و export/android/java_sdk_path

# 3) استيراد ثم تصدير
godot --headless --editor --path . --quit
mkdir -p build
godot --headless --path . --export-debug "Android" build/SADDAM-HERO.apk

# 4) تحقق
apksigner verify build/SADDAM-HERO.apk
```

المخرج: `build/SADDAM-HERO.apk` موقّع بمفتاح التصحيح، معماريّة `arm64-v8a`، أدنى إصدار أندرويد 5.0 (API 21)، والهدف API 34.

> هذا التوقيع توقيع تصحيح للتجربة فقط، وليس صالحًا للنشر على Google Play. للنشر يلزم مفتاح إصدار خاص (release keystore).

## بنية المشروع

```
project.godot            إعدادات المشروع والإدخال
export_presets.cfg       إعدادات تصدير Android وWeb
scenes/                  المشاهد: main، player، enemy، hud
scripts/                 منطق اللعب: اللاعب، السلاح، العدو، الصحة، الـHUD، مدير اللعبة
data/missions.json       بيانات الحملة
tests/README.md          ملاحظات الاختبار
.github/workflows/       بناء APK آليًا
```

## الحالة

نموذج لعب أولي قابل للتشغيل والبناء، وليس اللعبة النهائية. المرحلة التالية: مهام قابلة للعب، أسلحة متعددة، مراحل، أصوات، وحفظ التقدم.

## خارطة الطريق

1. تأسيس المشروع وبناء APK — تم.
2. اللاعب والكاميرا والقتال الأساسي — نموذج أولي.
3. المهام والحملة — بنية بيانات فقط.
4. الأصوات والواجهات واللمسات النهائية — لم تبدأ.
