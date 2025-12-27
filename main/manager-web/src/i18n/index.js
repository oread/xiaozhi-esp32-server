import Vue from 'vue';
import VueI18n from 'vue-i18n';
import zhCN from './zh_CN';
import zhTW from './zh_TW';
import en from './en';

Vue.use(VueI18n);

// 从本地存储获取语言设置；未设置则默认英文
const getDefaultLanguage = () => {
  const savedLang = localStorage.getItem('userLanguage');
  return savedLang || 'en';
};

const i18n = new VueI18n({
  locale: getDefaultLanguage(),
  // 设置英文为回退语言，确保缺失翻译时显示英文
  fallbackLocale: 'en',
  messages: {
    'zh_CN': zhCN,
    'zh_TW': zhTW,
    'en': en
  }
});

export default i18n;

// 提供一个方法来切换语言
export const changeLanguage = (lang) => {
  i18n.locale = lang;
  localStorage.setItem('userLanguage', lang);
  // 通知组件语言已更改
  Vue.prototype.$eventBus.$emit('languageChanged', lang);
};