# Generated by Django 4.1.7 on 2024-01-08 15:05

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('Movie', '0008_remove_quote_poster_image_quote_poster_url'),
    ]

    operations = [
        migrations.RenameModel(
            old_name='Quote',
            new_name='Quotation',
        ),
    ]