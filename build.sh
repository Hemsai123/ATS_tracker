#!/usr/bin/env bash
# exit on error
set -o errexit

cd backend
pip install -r requirements.txt
python manage.py collectstatic --no-input
python manage.py migrate

python manage.py shell -c "
import os
from accounts.models import User

admin_email = os.environ.get('INITIAL_ADMIN_EMAIL', 'admin@earlyjobs.in')
admin_pass = os.environ.get('INITIAL_ADMIN_PASSWORD', 'Admin1234!')
if not User.objects.filter(email=admin_email).exists():
    User.objects.create_superuser(email=admin_email, password=admin_pass, full_name='System Admin')
    print('Created production admin:', admin_email)

recruiter_email = os.environ.get('INITIAL_RECRUITER_EMAIL', 'hemsai@earlyjobs.in')
recruiter_pass = os.environ.get('INITIAL_RECRUITER_PASSWORD', 'Password123!')
if not User.objects.filter(email=recruiter_email).exists():
    User.objects.create_user(
        email=recruiter_email,
        password=recruiter_pass,
        full_name='Hemsai',
        role=User.ROLE_RECRUITER,
        is_email_verified=True,
        approval_status=User.APPROVAL_APPROVED,
        is_approved=True
    )
    print('Created production recruiter:', recruiter_email)
"
