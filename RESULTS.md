# תוצאות פרויקט הגמר — Terraform + AWS

מגיש: sagi50

## המערכת שנבנתה

אפליקציית הצבעה הכוללת שלושה שירותים:
vote מקבל הצבעות, worker מעביר אותן מ־Redis ל־PostgreSQL,
ו־result מציג את התוצאות.

התשתית הוקמה באמצעות Terraform באזור eu-north-1.
נוצרו סביבות dev ו־prod עם רשתות וקובצי state נפרדים.
ב־dev הוגדר עותק אחד מכל שירות וב־prod שני עותקים.

## F1 — פריסה ופעולת המערכת

תהליך GitHub Actions בנה את שלוש התמונות ופרס ל־dev.
לאחר הצלחת הבדיקות ואישור ידני, התהליך פרס גם ל־prod.

בדיקות Smoke test ו־Verify deployed version עברו בשתי הסביבות.
בוצעה הצבעה ונבדק שהתוצאות מתעדכנות.
ב-prod התגלתה תקלה בחיבור Socket.IO עם שני עותקים של result.
התקלה תוקנה באמצעות cookie stickiness בקבוצת היעד של result,
והתיקון נפרס דרך ה-pipeline.

תיקון התקלה:
https://github.com/sagi50/terraform-aws-final-project/pull/1

## F2 — הפרדת הגדרות בין הסביבות

נפתח Pull Request שהוסיף option_a = "Pizza" לקובץ dev.tfvars בלבד.

בתוכנית dev הופיע שינוי OPTION_A מביבי ל-Pizza.
בתוכנית prod לא הופיע שינוי באפשרויות ההצבעה.
לאחר המיזוג והפריסה נבדק בדפדפן:
ב-dev הופיעה Pizza, וב-prod נשארו ביבי ואייזנקוט.

בקשת המיזוג:
https://github.com/sagi50/terraform-aws-final-project/pull/2

## F3 — שינוי תוכן ופריסת גרסה חדשה

נפתח Pull Request ששינה את משפט העזרה בעמוד ההצבעה ל:
"Version 2: you can change your vote".

לאחר המיזוג הגרסה נפרסה ל-dev.
פריסת prod המתינה לאישור ידני ולאחר האישור הסתיימה בהצלחה.
הטקסט החדש אומת בדפדפן ב-dev.

מגבלת התיעוד:
הופעלה בדיקת זמינות והתקבלו תשובות HTTP 200 בחלון הבדיקה,
אך לא נשמר תיעוד רציף המכסה את כל הפריסה.
לכן אין בתיעוד הוכחה מלאה להיעדר השבתה לאורך כל העדכון.

בקשת המיזוג:
https://github.com/sagi50/terraform-aws-final-project/pull/3

ריצת הפריסה:
https://github.com/sagi50/terraform-aws-final-project/actions/runs/41705916904

## F4 — גרסה תקולה וזיהוי חזרה לגרסה קודמת

נוסף בכוונה raise SystemExit(1) בתחילת services/vote/app.py.
הבדיקות והבנייה ב-Pull Request עברו, ולאחר המיזוג החל ניסיון הפריסה ל-dev.

תוצאות ה-pipeline:
- Apply infrastructure הסתיים בהצלחה.
- Smoke test הסתיים בהצלחה.
- Verify deployed version נכשל והציג:
  "Changes remain after deployment. Check for an ECS rollback."
- פריסת prod דולגה.

במהלך המעקב אחר ניסיון הפריסה נצפו תשובות HTTP 200.
נשמר פלט מקומי ב-~/project-evidence/F4-availability.log.
הצירוף של זמינות האתר וכישלון בדיקת התאמת הגרסה תואם לחזרה לגרסה הקודמת.
לא צורף כאן צילום של אירוע rollback מתוך מסוף ECS.

בסיום הבדיקה הוסרה שורת התקלה והקוד התקין הועלה ל-main.

בקשת המיזוג:
https://github.com/sagi50/terraform-aws-final-project/pull/4

## F5 — מחיקת המשאבים

המשאבים נמחקו בסדר הבא:
1. prod — 44 משאבים.
2. dev — 44 משאבים.
3. bootstrap — 13 משאבים.

לאחר המחיקה התקבלו רשימות ריקות בבדיקות:
ECS, RDS, ElastiCache, ALB, ECR, Secrets Manager,
CloudWatch Logs, EC2 instances, EBS volumes, Elastic IPs ו-NAT Gateways
באזור eu-north-1.
גם רשימת דליי S3 בחשבון הייתה ריקה.

הבדיקות אינן סריקה מלאה של כל השירותים בכל אזורי AWS.
הקוד והיסטוריית GitHub נשמרו. כתובות האפליקציה אינן פעילות לאחר הניקוי.

## היסטוריית הריצות

https://github.com/sagi50/terraform-aws-final-project/actions
