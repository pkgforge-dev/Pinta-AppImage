/*
 * Stub libappstream.so.5
 *
 * libadwaita links a handful of AppStream symbols (used only by the
 * AdwAboutWindow metadata feature). Replace libappstream with this stub
 * This removes the real libappstream and its entire dependency hell
 * (libcurl, libkrb5, libssh2, libngtcp2, ...).
 *
 * Build:
 *   cc -shared -fPIC -O2 -o libappstream.so.5 -Wl,-soname,libappstream.so.5 libappstream-stub.c
 */

#define NULL ((void *)0)
typedef int gboolean;
typedef void *gpointer;
typedef const void *gconstpointer;
typedef const char *gchar;
typedef gpointer AsMetadata;
typedef gpointer AsComponent;
typedef gpointer AsDeveloper;
typedef gpointer AsLaunchable;
typedef gpointer AsRelease;
typedef gpointer AsReleaseList;

/* AsMetadata */
gpointer as_metadata_new(void) { return NULL; }
gboolean as_metadata_parse_file(gpointer self, gconstpointer file, gboolean strict, gpointer cancellable, gpointer error) { (void)self; (void)file; (void)strict; (void)cancellable; (void)error; return 0; }
gpointer as_metadata_get_component(gpointer self) { (void)self; return NULL; }

/* AsComponent */
gchar *as_component_get_name(gpointer self) { (void)self; return NULL; }
gchar *as_component_get_id(gpointer self) { (void)self; return NULL; }
gchar *as_component_get_developer(gpointer self) { (void)self; return NULL; }
gpointer as_component_get_launchable(gpointer self, gconstpointer kind) { (void)self; (void)kind; return NULL; }
gchar *as_component_get_project_license(gpointer self) { (void)self; return NULL; }
gpointer as_component_get_releases_plain(gpointer self) { (void)self; return NULL; }
gchar *as_component_get_url(gpointer self, gconstpointer kind) { (void)self; (void)kind; return NULL; }

/* AsDeveloper */
gchar *as_developer_get_name(gpointer self) { (void)self; return NULL; }

/* AsLaunchable */
gpointer as_launchable_get_entries(gpointer self, gconstpointer kind) { (void)self; (void)kind; return NULL; }

/* AsRelease */
gchar *as_release_get_description(gpointer self, gconstpointer locale) { (void)self; (void)locale; return NULL; }
gchar *as_release_get_version(gpointer self) { (void)self; return NULL; }

/* AsReleaseList */
gpointer as_release_list_get_entries(gpointer self) { (void)self; return NULL; }
