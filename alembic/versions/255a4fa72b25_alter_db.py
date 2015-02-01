"""alter db

Revision ID: 255a4fa72b25
Revises: None
Create Date: 2015-01-21 21:14:30.129552

"""

# revision identifiers, used by Alembic.
revision = '255a4fa72b25'
down_revision = None

from alembic import op
import sqlalchemy as sa

def upgrade():
    op.alter_column("task", "title", type_=sa.String(128))


def downgrade():
    op.alter_column("task", "title", type_=sa.String(32))
