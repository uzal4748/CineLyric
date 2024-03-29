# Generated by Django 5.0.1 on 2024-02-29 08:51

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Song', '0009_newtracklyric_delete_musiclyric_delete_songlyric'),
    ]

    operations = [
        migrations.CreateModel(
            name='NewSpotifyLyric',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('artist_name', models.CharField(max_length=255)),
                ('artist_image', models.URLField(blank=True, null=True)),
                ('track_name', models.CharField(max_length=255)),
                ('genre', models.CharField(max_length=255)),
                ('type', models.CharField(default='music', max_length=255)),
                ('lyrics', models.TextField()),
                ('release_date', models.IntegerField()),
                ('youtube_link', models.URLField(blank=True, null=True)),
                ('spotify_link', models.URLField(blank=True, null=True)),
                ('album', models.CharField(blank=True, max_length=255, null=True)),
            ],
        ),
    ]
