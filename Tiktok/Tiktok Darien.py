# Espacio de trabajo, variables locales, Cookies
import pandas as pd
import numpy as np
from tiktokapipy.async_api import AsyncTikTokAPI

#from TikTokApi import TikTokApi
#csrf_session_id_TikTok = 'verify_lcr1tv3c_3Ymjw5Dz_aaGR_4JMF_BFnC_Qr6c4kkpKa9W'
#api = TikTokApi(custom_verify_fp=csrf_session_id_TikTok)
#user_videos =  api.user(username).info_full()
from tiktokapipy.api import TikTokAPI
def recopilar_videos_usuario(n_videos, username):
    df_usuario = pd.DataFrame()
    comments = list()
    with TikTokAPI(navigator_type='firefox', navigation_retries=2, navigation_timeout=10, scroll_down_time=10) as api:
        user = api.user(username, n_videos)
        for video in user.videos:
            num_comments = video.stats.comment_count
            num_likes = video.stats.digg_count
            num_views = video.stats.play_count
            num_shares = video.stats.share_count
            #comments = video.comments
            d = {'num_comments': num_comments, 'num_likes': num_likes, 'num_views': num_views, 'num_shares': num_shares}
            df_usuario = df_usuario.append(d, ignore_index =True)
    return df_usuario
#df_usuario = recopilar_videos_usuario(1, 'elpumajoseluisr')
#df_usuario
async def recopilar_comentarios_video_async(video_link):
    async with AsyncTikTokAPI(navigator_type='firefox', navigation_retries=2, navigation_timeout=10, scroll_down_time=10) as api:
        video = await api.video(video_link)
    return await video
#recopilar_comentarios_video_async('https://www.tiktok.com/@lacarito2022/video/7121466607200701701?is_copy_url=1&is_from_webapp=v1&item_id=7121466607200701701&q=%23dariennoticias&t=1664984355496')
def recopilar_comentarios_video(video_url):
    with TikTokAPI(navigator_type='firefox', navigation_retries=2, navigation_timeout=10, scroll_down_time=400, headless=True, data_dump_file='dump_try.json') as api:
        video = api.video(video_url)
        comments = video.comments
        print(comments)
        return video.stats
recopilar_comentarios_video('https://www.tiktok.com/@lacarito2022/video/7121466607200701701')