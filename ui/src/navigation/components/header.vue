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
          <svg id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 252 252"><defs></defs><title>Artboard 1</title><rect class="cls-1" x="36.17" y="36.16" width="180" height="181.43"/><polygon class="cls-2" points="192.27 108.37 178.9 108.37 178.13 108.37 177.78 109.07 168.09 129.25 158.36 109.06 158.02 108.37 157.25 108.37 144.33 108.37 143.11 108.37 143.11 109.6 143.11 116.48 143.11 117.71 144.33 117.71 146.54 117.71 146.54 146.61 144.15 146.61 142.92 146.61 142.92 147.84 142.92 154.72 142.92 155.95 144.15 155.95 158.66 155.95 159.89 155.95 159.89 154.72 159.89 147.84 159.89 146.61 158.66 146.61 156.15 146.61 156.15 126.1 166.99 148.45 168.09 150.73 169.21 148.45 180.16 126.05 180.16 146.61 177.77 146.61 176.53 146.61 176.53 147.84 176.53 154.72 176.53 155.95 177.77 155.95 192.27 155.95 193.5 155.95 193.5 154.72 193.5 147.84 193.5 146.61 192.27 146.61 189.77 146.61 189.77 117.71 192.27 117.71 193.5 117.71 193.5 116.48 193.5 109.6 193.5 108.37 192.27 108.37"/><path class="cls-2" d="M108,146.58h-3.86l-12.56-29H94V108.2H73.84v9.35h2.78l-12.55,29H58.84v9.35h18.3v-9.35H74.48l2.09-4.83h15.1l2.08,4.83H90.94v9.35h18.31v-9.35ZM87.62,132.41h-7l3.5-8.11Z"/><polygon class="cls-2" points="176.91 72.08 75.1 72.08 73.69 72.08 73.69 73.49 73.69 100.69 73.69 102.1 75.1 102.1 92.68 102.1 94.09 102.1 94.09 100.69 94.09 90.59 115.81 90.59 115.81 162.26 105.7 162.26 104.3 162.26 104.3 163.67 104.3 181.25 104.3 182.66 105.7 182.66 146.3 182.66 147.71 182.66 147.71 181.25 147.71 163.67 147.71 162.26 146.3 162.26 136.21 162.26 136.21 90.59 157.8 90.59 157.8 100.56 157.8 101.97 159.21 101.97 176.91 101.97 178.32 101.97 178.32 100.56 178.32 73.49 178.32 72.08 176.91 72.08"/><polygon class="cls-3" points="139.22 170.63 143.52 166.2 143.52 178.34 139.22 174.23 139.22 170.63"/><polygon class="cls-3" points="132.06 166.52 127.75 170.76 127.75 82.14 132.06 86.43 132.06 166.52"/><polygon class="cls-3" points="82.31 80.58 77.89 76.28 171.98 76.28 166.42 80.58 82.31 80.58"/><polygon class="cls-3" points="174.26 98.03 169.96 93.92 169.96 82.98 174.26 78.56 174.26 98.03"/><path class="cls-1" d="M222.57,214a3.61,3.61,0,1,1,3.61,3.61A3.61,3.61,0,0,1,222.57,214Zm6.34,0a2.73,2.73,0,1,0-2.73,2.91A2.77,2.77,0,0,0,228.91,214Zm-4.12-2.06h1.52c1,0,1.51.34,1.51,1.2a1,1,0,0,1-1.07,1.1l1.1,1.79h-.78L226,214.25h-.46V216h-.76Zm.76,1.75h.67c.45,0,.84-.06.84-.61s-.44-.56-.83-.56h-.68Z"/>
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
