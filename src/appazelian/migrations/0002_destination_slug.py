# Generated by Django 4.0.6 on 2022-07-13 18:09

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('appazelian', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='destination',
            name='slug',
            field=models.SlugField(default='none'),
            preserve_default=False,
        ),
    ]