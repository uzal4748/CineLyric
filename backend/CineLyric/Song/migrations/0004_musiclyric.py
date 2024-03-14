# Generated by Django 4.1.7 on 2024-01-08 15:56

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Song', '0003_delete_musiclyric'),
    ]

    operations = [
        migrations.CreateModel(
            name='MusicLyric',
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
