from ansible.plugins.callback import CallbackBase

# Automatically add tags to each role
# Based on https://gist.github.com/rkrzr/f5387167fa7b4869e2dca8b713879562
#
# Limitation: If a role/block has a variable tag, e.g. 'php{{ php_version }}'
# this fails because it causes Ansible to evaluate the variables before they are
# defined. I haven't been able to find a way around that.
class CallbackModule(CallbackBase):

    def v2_playbook_on_play_start(self, play):
        self.tag_roles(play.get_roles())

    def tag_roles(self, roles):
        for role in roles:
            self.tag_role(role)
            self.tag_roles(role.get_direct_dependencies())

    def tag_role(self, role):
        role_name = role._role_name
        self.tag(role, role_name)

        # The is useful for roles that have a lot of dependencies that don't need to be run
        for block in role.get_task_blocks():
            self.tag(block, f"{role_name}-only")

    def tag(self, taggable, tag):
        if tag not in taggable.tags:
            taggable.tags += [tag]
