from ansible.plugins.callback import CallbackBase

# Based on https://gist.github.com/rkrzr/f5387167fa7b4869e2dca8b713879562
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
        for block in role.get_task_blocks():
            self.tag(block, f"{role_name}-only")

    def tag(self, taggable, tag):
        if tag not in taggable.tags:
            taggable.tags += [tag]
