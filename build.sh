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
admin_user, _ = User.objects.get_or_create(
    email=admin_email,
    defaults={'full_name': 'System Admin', 'role': User.ROLE_ADMIN}
)
admin_user.set_password(admin_pass)
admin_user.role = User.ROLE_ADMIN
admin_user.is_staff = True
admin_user.is_superuser = True
admin_user.is_active = True
admin_user.is_email_verified = True
admin_user.approval_status = User.APPROVAL_APPROVED
admin_user.is_approved = True
admin_user.save()
print('Configured admin account:', admin_email)

recruiter_email = os.environ.get('INITIAL_RECRUITER_EMAIL', 'hemsai@earlyjobs.in')
recruiter_pass = os.environ.get('INITIAL_RECRUITER_PASSWORD', 'Password123!')
rec_user, _ = User.objects.get_or_create(
    email=recruiter_email,
    defaults={'full_name': 'Hemsai', 'role': User.ROLE_RECRUITER}
)
rec_user.set_password(recruiter_pass)
rec_user.role = User.ROLE_RECRUITER
rec_user.is_active = True
rec_user.is_email_verified = True
rec_user.approval_status = User.APPROVAL_APPROVED
rec_user.is_approved = True
rec_user.save()
print('Configured recruiter account:', recruiter_email)
"
