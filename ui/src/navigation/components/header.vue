<template>
  <div class="ivu-menu ivu-menu-primary ivu-menu-horizontal row m-0">
    <div class="col-10 d-flex align-items-center">
      <VButton
        :to="{ name: 'home' }"
        type="primary"
        class="d-flex align-items-center justify-content-center"
        :style="{ width: '44px', height: '42px' }"
      >
        <div class="d-flex align-items-center">
          <svg width="35" height="35" viewBox="0 0 168 138" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M166.25 45.21H149.59H148.62L148.2 46.08L136.11 71.23L123.99 46.08L123.58 45.21H122.61H106.52H104.98V46.74V55.32V56.85H106.52H109.27V92.86H106.29H104.75V94.4V102.97V104.51H106.29H124.37H125.91V102.97V94.4V92.86H124.37H121.24V67.31L134.75 95.17L136.12 98.01L137.51 95.17L151.16 67.25V92.86H148.17H146.63V94.4V102.97V104.51H148.17H166.25H167.79V102.97V94.4V92.86H166.25H163.14V56.85H166.25H167.79V55.32V46.74V45.21H166.25Z" fill="white"/>
          <path d="M61.27 92.83H56.47L40.81 56.66H43.81V45H18.68V56.66H22.14L6.5 92.83H0V104.47H22.81V92.83H19.48L22.08 86.83H40.9L43.5 92.83H39.98V104.47H62.81V92.83H61.27ZM35.9 75.16H27.11L31.48 65.05L35.9 75.16Z" fill="white"/>
          <path d="M147.12 0H18.49V37.4H43.89V23.05H70.97V112.38H56.63V137.78H110.73V112.38H96.4V23.05H123.3V37.24H148.89V0H147.14H147.12ZM100.04 122.89L105.4 117.38V132.53L100.04 127.4V122.89ZM91.09 117.77L85.73 123.06V12.52L91.09 17.89V117.77ZM29.09 10.56L23.56 5.19H140.89L133.95 10.56H29.09ZM143.79 32.34L138.43 27.22V13.57L143.79 8.05V32.34Z" fill="white"/>
          <path d="M116.66 132.51C116.66 130.407 117.927 128.511 119.87 127.706C121.813 126.901 124.05 127.346 125.537 128.833C127.024 130.32 127.469 132.557 126.664 134.5C125.859 136.443 123.963 137.71 121.86 137.71C118.99 137.705 116.666 135.38 116.66 132.51ZM125.8 132.51C125.664 130.372 123.844 128.734 121.704 128.823C119.563 128.913 117.886 130.696 117.929 132.838C117.971 134.98 119.718 136.696 121.86 136.7C122.944 136.685 123.976 136.23 124.719 135.441C125.461 134.651 125.852 133.593 125.8 132.51ZM119.86 129.51H122.05C123.46 129.51 124.22 130.01 124.22 131.24C124.255 131.663 124.106 132.08 123.811 132.385C123.516 132.689 123.104 132.852 122.68 132.83L124.26 135.41H123.14L121.61 132.89H120.95V135.43H119.89L119.86 129.51ZM120.96 132.03H121.96C122.61 132.03 123.17 131.95 123.17 131.16C123.17 130.37 122.54 130.35 121.98 130.35H120.98V132.03H120.96Z" fill="white"/>
          </svg>
        </div>
      </VButton>
      <template v-if="!widthLessThan('sm')">
        <VButton
          v-if="canReadReports && reportsLink"
          type="primary"
          :to="{ name: 'reports' }"
          class="header-btn ms-2"
          size="large"
        >
          {{ reportsLink.name }}
        </VButton>
        <VButton
          v-if="$can('read', 'Motor::Form') && formsLink"
          type="primary"
          class="header-btn ms-2"
          size="large"
          :to="{ name: 'forms' }"
        >
          {{ formsLink.name }}
        </VButton>
        <VButton
          v-for="link in linksToRender"
          :key="link.name"
          type="primary"
          class="header-btn ms-2"
          :target="link.target"
          size="large"
          :to="link.to"
        >
          {{ link.name }}
        </VButton>
        <VButton
          v-if="$can('manage', 'Motor::Config')"
          type="primary"
          class="ms-2 add-item-btn"
          icon="md-add"
          @click="openEditModal"
        />
      </template>
    </div>
    <div class="col-2 d-flex justify-content-end align-items-center">
      <Dropdown
        v-if="currentUser?.email"
        trigger="click"
        :placement="'bottom-end'"
        class="ms-2"
      >
        <VButton
          v-if="currentUser"
          type="primary"
          class="header-btn ms-2"
          size="large"
        >
          <Icon
            type="md-contact"
            class="d-block d-sm-none"
            size="large"
          />
          <span class="d-none d-sm-block">
            {{ currentUser.email }}
          </span>
        </VButton>
        <template #list>
          <DropdownMenu>
            <DropdownItem
              v-for="link in linksToRenderForUserDropdown"
              :key="link.name"
            >
              <VButton
                type="text"
                :target="link.target"
                :to="link.to"
                class="p-0 bg-transparent text-dark"
                style="line-height: unset; height: unset"
              >
                {{ link.name }}
              </VButton>
            </DropdownItem>
            <DropdownItem
              :divided="linksToRenderForUserDropdown.length !== 0"
              @click="signOut"
            >
              <Icon
                type="md-exit"
                size="large"
              />
              {{ i18n['sign_out'] }}
            </DropdownItem>
          </DropdownMenu>
        </template>
      </Dropdown>
      <VButton
        v-if="isStandalone && !currentUser?.email"
        type="primary"
        class="header-btn ms-2"
        size="large"
        :to="(basePath + '/sign_in').replace('//', '/')"
      >
        Log In
      </VButton>
      <VButton
        v-if="!isShowSettings && currentUser.showHelp"
        type="primary"
        size="large"
        class="header-btn"
        @click="openGuides"
      >
        <Icon
          type="md-help"
          size="large"
        />
      </VButton>
      <VButton
        v-if="!isShowSettings && adminSettingsPath && $can('manage', 'all')"
        type="primary"
        size="large"
        class="header-btn"
        :to="adminSettingsPath"
      >
        <Icon
          type="md-person-add"
          size="large"
        />
      </VButton>
      <Badge
        v-if="notificationsCount && $can('read', 'Motor::Notification')"
        :count="notificationsCount"
        type="error"
      >
        <VButton
          v-if="$can('read', 'Motor::Notification')"
          type="primary"
          class="ms-2 header-btn"
          size="large"
          :to="{ name: 'notifications' }"
        >
          <Icon
            type="md-notifications"
            size="large"
          />
        </VButton>
      </Badge>
      <VButton
        v-if="!isShowSettings"
        type="primary"
        size="large"
        class="ms-2 header-btn"
        @click="openSearch"
      >
        <Icon
          type="md-search"
          size="large"
        />
      </VButton>
      <Dropdown
        v-if="!isShowSettings && isShowCreateButton"
        trigger="click"
        :placement="$can('manage', 'all') ? 'bottom' : 'bottom-end'"
        class="ms-2"
      >
        <VButton
          type="primary"
          size="large"
          class="header-btn"
        >
          <Icon
            type="md-add"
            size="large"
          />
        </VButton>
        <template #list>
          <DropdownMenu>
            <DropdownItem
              v-if="$can('create', 'Motor::Query')"
              @click="$router.push({ name: 'new_query' })"
            >
              {{ i18n['add_query'] }}
            </DropdownItem>
            <DropdownItem
              v-if="$can('create', 'Motor::Dashboard')"
              @click="$router.push({ name: 'new_dashboard' })"
            >
              {{ i18n['add_dashboard'] }}
            </DropdownItem>
            <DropdownItem
              v-if="$can('create', 'Motor::Form')"
              @click="$router.push({ name: 'new_form'})"
            >
              {{ i18n['add_form'] }}
            </DropdownItem>
            <DropdownItem
              v-if="$can('create', 'Motor::Alert')"
              @click="$router.push({ name: 'new_alert' })"
            >
              {{ i18n['add_alert'] }}
            </DropdownItem>
          </DropdownMenu>
        </template>
      </Dropdown>
      <VButton
        v-if="$can('manage', 'all')"
        type="primary"
        class="ms-2 header-btn"
        size="large"
        @click="onSettingsClick"
      >
        <Icon
          :type="isShowSettings ? 'md-close' : 'md-settings'"
          size="large"
        />
        <span
          v-if="isShowSettings"
          style="vertical-align: middle"
        >{{ i18n['close_settings'] }}</span>
      </VButton>
    </div>
  </div>
</template>

<script>
import api from 'api'
import Search from './search'
import Guides from './guides'
import LinksEdit from './links_edit'
import { modelSlugMap, modelNameMap } from 'data_resources/scripts/schema'
import { linksStore } from '../scripts/links_store'
import { basePath, adminSettingsPath, isStandalone } from 'utils/scripts/configs'
import { widthLessThan } from 'utils/scripts/dimensions'
import { isShowSettings, toggleSettings } from 'settings/scripts/toggle'
import { openSettingsDrawer } from 'settings/scripts/drawer'
import { currentUser } from 'navigation/scripts/user_store'
import { canVisit } from '../scripts/can_visit'
import { notificationsBus } from 'notes/scripts/subscriptions'

export default {
  name: 'AppHeader',
  data () {
    return {
      notificationsCount: 0
    }
  },
  computed: {
    isShowSettings,
    isStandalone: () => isStandalone,
    basePath: () => basePath,
    currentUser: () => currentUser,
    adminSettingsPath: () => adminSettingsPath,
    reportsLink () {
      return this.links.find((l) => l.link_type === 'reports')
    },
    formsLink () {
      return this.links.find((l) => l.link_type === 'forms')
    },
    canReadReports () {
      return this.$can('read', 'Motor::Query') || this.$can('read', 'Motor::Dashboard') || this.$can('read', 'Motor::Alert')
    },
    isShowCreateButton () {
      return this.$can('create', 'Motor::Query') || this.$can('create', 'Motor::Dashboard') || this.$can('create', 'Motor::Alert') || this.$can('create', 'Motor::Form')
    },
    links () {
      return linksStore
    },
    linksToRenderForUserDropdown () {
      return this.normalizeLinks(this.links.filter((l) => l.link_type === 'user_dropdown'))
    },
    linksToRender () {
      return this.normalizeLinks(this.links.filter((l) => (!l.link_type || l.link_type === 'header') && !['forms', 'reports'].includes(l.link_type)))
    },
    currentResource () {
      if (this.$route.name !== 'resources') {
        return
      }

      return this.$route.params.fragments.reduce((acc, slug, index) => {
        if (index % 2 === 0) {
          return (
            modelNameMap[acc.associations?.find((assoc) => assoc.slug === slug)?.model_name] ||
            modelSlugMap[slug]
          )
        } else {
          return acc
        }
      }, {})
    }
  },
  mounted () {
    this.loadNotificationsCount()

    notificationsBus.on('notify', (data) => {
      this.loadNotificationsCount()

      Notification.requestPermission().then((result) => {
        const notification = new Notification(data.title, { body: data.description, icon: '/apple-touch-icon.png' })

        return notification
      })
    })

    notificationsBus.on('update', (data) => {
      this.loadNotificationsCount()
    })
  },
  methods: {
    widthLessThan,
    openSettingsDrawer,
    normalizeLinks (links) {
      return links.map((link) => {
        const params = { name: link.name }

        const path = link.path.replace(location.origin, '').replace(new RegExp(`^${basePath}`), '/')

        params.to = path

        if (path.match(/^https?:/)) {
          params.target = '_blank'

          return params
        }

        const resolvedRoute = this.$router.resolve({ path }, this.$route)

        if (resolvedRoute?.name) {
          if (canVisit(resolvedRoute)) {
            return params
          } else {
            return null
          }
        } else {
          return params
        }
      }).filter(Boolean)
    },
    loadNotificationsCount () {
      api.get('notifications', {
        params: {
          page: {
            limit: 0,
            offset: 0
          },
          filter: {
            status: 'pending'
          },
          meta: 'count'
        }
      }).then((result) => {
        this.notificationsCount = result.data.meta.count
      })
    },
    signOut () {
      api.delete('session').then(() => {
        document.location.href = '/'
      })
    },
    openSearch () {
      this.$Modal.open(Search, {
        placeholder: this.i18n.search_placeholder,
        onSelected: (value) => {
          this.$Modal.remove()
        }
      })
    },
    openGuides () {
      this.$Modal.open(Guides, {
      }, {
        closable: true,
        className: 'modal-size-large'
      })
    },
    openEditModal () {
      this.$Drawer.open(LinksEdit, {
      }, {
        title: this.i18n.links,
        closable: true
      })
    },
    onSettingsClick () {
      if (this.isShowSettings) {
        return toggleSettings()
      }

      if (['resources'].includes(this.$route.name) && !widthLessThan('sm')) {
        toggleSettings()
      } else {
        openSettingsDrawer({ selectedResource: this.currentResource })
      }
    }
  }
}
</script>

<style lang="scss" scoped>
:deep(.ivu-badge-count) {
  top: 0
}

.header-btn {
  font-size: 15px;
  font-weight: 500;
  display: flex;
  align-items: center;

  .ion {
    vertical-align: sub;
    line-height: 1;
  }

  .ion-md-search {
    font-size: 24px;
  }
  .ion-md-add {
    font-size: 26px;
  }
  .ion-md-settings {
    font-size: 22px;
  }
  .ion-md-help {
    font-size: 24px;
  }
  .ion-md-person-add {
    font-size: 26px;
  }
  .ion-md-contact {
    font-size: 27px;
  }
  .ion-md-close {
    font-size: 20px;
  }
  .ion-md-notifications {
    font-size: 22px;
  }
}
</style>
