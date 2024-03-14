# Generated by Django 4.1.7 on 2024-01-09 16:42

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Song', '0004_musiclyric'),
    ]

    operations = [
        migrations.CreateModel(
            name='BillBoardLyric',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('artist_name', models.CharField(max_length=255)),
                ('track_name', models.CharField(max_length=255)),
                ('genre', models.CharField(max_length=255)),
                ('lyrics', models.TextField()),
                ('release_date', models.IntegerField()),
            ],
        ),
    ]
